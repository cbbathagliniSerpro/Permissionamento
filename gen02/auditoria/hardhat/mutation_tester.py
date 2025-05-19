import os
import re
import subprocess
import random
import argparse
from pathlib import Path
import shutil
import json
from typing import List, Dict, Tuple, Optional

class SolidityMutator:
    """Class to handle Solidity contract mutations"""
    
    MUTATION_OPERATORS = {
        'arithmetic': [
            ('+', '-'),
            ('-', '+'),
            ('*', '/'),
            ('/', '*'),
            ('%', '*'),
            ('**', '*'),
            ('+=', '-='),
            ('-=', '+='),
            ('*=', '/='),
            ('/=', '*='),
            ('%=', '*='),
        ],
        'logical': [
            ('&&', '||'),
            ('||', '&&'),
            ('!', ''),
            ('==', '!='),
            ('!=', '=='),
            ('<', '>='),
            ('>', '<='),
            ('<=', '>'),
            ('>=', '<'),
        ],
        'assignment': [
            ('=', '=='),
            ('==', '='),
        ],
        'unary': [
            ('++', '--'),
            ('--', '++'),
        ],
        'delete': [
            ('delete', '// delete'),
        ],
        'require': [
            ('require(', '// require('),
            ('revert(', '// revert('),
        ],
        'visibility': [
            ('public', 'private'),
            ('external', 'internal'),
        ],
        'payable': [
            ('payable', ''),
        ]
    }
    
    def __init__(self, contract_path: str):
        self.contract_path = contract_path
        self.original_code = self._read_contract()
        self.mutations = []
        
    def _read_contract(self) -> str:
        """Read the original contract content"""
        with open(self.contract_path, 'r') as f:
            return f.read()
    
    def _write_mutation(self, mutation_code: str, mutation_id: int):
        """Write a mutated contract to a temporary file"""
        mutated_path = self.contract_path.replace('.sol', f'_mutated_{mutation_id}.sol')
        with open(mutated_path, 'w') as f:
            f.write(mutation_code)
        return mutated_path
    
    def _restore_original(self):
        """Restore the original contract"""
        with open(self.contract_path, 'w') as f:
            f.write(self.original_code)
    
    def generate_mutations(self, max_mutations: int = 10) -> List[Tuple[int, str, str]]:
        """Generate multiple mutations of the contract"""
        self.mutations = []
        lines = self.original_code.split('\n')
        
        mutation_count = 0
        attempts = 0
        max_attempts = max_mutations * 2  # Try a bit harder to find mutations
        
        while mutation_count < max_mutations and attempts < max_attempts:
            attempts += 1
            line_num = random.randint(0, len(lines) - 1)
            original_line = lines[line_num]
            
            # Skip empty lines, comments, and pragma directives
            if (not original_line.strip() or 
                original_line.strip().startswith('//') or 
                original_line.strip().startswith('pragma') or
                original_line.strip().startswith('import')):
                continue
                
            # Try different mutation operators
            for operator_type, operators in self.MUTATION_OPERATORS.items():
                for original, mutation in operators:
                    if original in original_line:
                        mutated_line = original_line.replace(original, mutation)
                        if mutated_line != original_line:
                            # Create a copy of lines to modify
                            new_lines = lines.copy()
                            new_lines[line_num] = mutated_line
                            mutation_code = '\n'.join(new_lines)
                            
                            # Store mutation info
                            mutation_id = mutation_count + 1
                            description = f"Line {line_num+1}: Replaced '{original}' with '{mutation}' ({operator_type})"
                            self.mutations.append((mutation_id, mutation_code, description))
                            mutation_count += 1
                            
                            if mutation_count >= max_mutations:
                                break
                if mutation_count >= max_mutations:
                    break
                    
        return self.mutations
    
    def apply_mutation(self, mutation_id: int) -> str:
        """Apply a specific mutation and return the path to the mutated file"""
        for mut_id, code, _ in self.mutations:
            if mut_id == mutation_id:
                return self._write_mutation(code, mutation_id)
        raise ValueError(f"Mutation ID {mutation_id} not found")
    
    def get_mutation_descriptions(self) -> Dict[int, str]:
        """Get descriptions of all generated mutations"""
        return {mut_id: desc for mut_id, _, desc in self.mutations}

class HardhatTestRunner:
    """Class to handle Hardhat test execution"""
    
    def __init__(self, project_root: str):
        self.project_root = project_root
        self.original_wd = os.getcwd()
        
    def __enter__(self):
        os.chdir(self.project_root)
        return self
        
    def __exit__(self, exc_type, exc_val, exc_tb):
        os.chdir(self.original_wd)
        
    def run_tests(self, test_file: Optional[str] = None) -> Tuple[bool, str]:
        """Run Hardhat tests and return success status and output"""
        cmd = ['npx', 'hardhat', 'test']
        if test_file:
            cmd.append(test_file)
            
        try:
            result = subprocess.run(
                cmd,
                check=False,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True
            )
            return result.returncode == 0, result.stdout
        except subprocess.CalledProcessError as e:
            return False, e.output

class MutationTester:
    """Main class to perform mutation testing"""
    
    def __init__(self, contract_path: str, test_path: str, project_root: str):
        self.contract_path = contract_path
        self.test_path = test_path
        self.project_root = project_root
        self.contract_name = Path(contract_path).stem
        self.mutator = SolidityMutator(contract_path)
        self.results = []
        
    def find_test_file(self) -> Optional[str]:
        """Find the test file corresponding to the contract"""
        test_dir = Path(self.project_root) / self.test_path
        
        # Look for files with the contract name or similar
        possible_names = [
            f"{self.contract_name}.test.js",
            f"{self.contract_name}.js",
            f"{self.contract_name}.spec.js",
            f"test_{self.contract_name}.js",
            f"{self.contract_name}Test.js",
        ]
        
        for test_file in test_dir.glob('*'):
            if test_file.name in possible_names:
                return str(test_file)
                
        # If not found by name, look for files that might import the contract
        for test_file in test_dir.glob('*.js'):
            with open(test_file, 'r') as f:
                content = f.read()
                if f"contracts/{self.contract_name}.sol" in content or \
                   f"../contracts/{self.contract_name}.sol" in content:
                    return str(test_file)
                    
        return None
    
    def run_mutation_test(self, max_mutations: int = 10):
        """Run the mutation testing process"""
        test_file = self.find_test_file()
        if not test_file:
            print(f"Error: Could not find test file for contract {self.contract_name}")
            return
            
        print(f"Found test file: {test_file}")
        print(f"Generating mutations for {self.contract_path}...")
        
        mutations = self.mutator.generate_mutations(max_mutations)
        if not mutations:
            print("Error: Could not generate any mutations for the contract")
            return
            
        print(f"Generated {len(mutations)} mutations")
        
        with HardhatTestRunner(self.project_root) as test_runner:
            # First run original tests to make sure they pass
            print("\nRunning original tests...")
            original_success, original_output = test_runner.run_tests(test_file)
            
            if not original_success:
                print("Original tests failed. Please fix tests before mutation testing.")
                print(original_output)
                return
                
            print("Original tests passed. Starting mutation testing...\n")
            
            # Test each mutation
            for mutation_id, mutation_code, description in mutations:
                print(f"\nTesting mutation {mutation_id}: {description}")
                
                # Apply mutation
                mutated_path = self.mutator._write_mutation(mutation_code, mutation_id)
                
                # Replace original contract with mutated version
                shutil.copy(mutated_path, self.contract_path)
                
                # Run tests
                success, output = test_runner.run_tests(test_file)
                
                # Record result
                result = {
                    'mutation_id': mutation_id,
                    'description': description,
                    'killed': not success,
                    'output': output
                }
                self.results.append(result)
                
                status = "KILLED" if not success else "SURVIVED"
                print(f"Mutation {mutation_id} {status}")
                
                # Clean up mutated file
                os.remove(mutated_path)
                
            # Restore original contract
            self.mutator._restore_original()
            
        self.report_results()
        
    def report_results(self):
        """Generate a report of mutation testing results"""
        if not self.results:
            print("No results to report")
            return
            
        total = len(self.results)
        killed = sum(1 for r in self.results if r['killed'])
        survived = total - killed
        mutation_score = (killed / total) * 100 if total > 0 else 0
        
        print("\nMutation Testing Report")
        print("=" * 80)
        print(f"Contract: {self.contract_path}")
        print(f"Total mutations: {total}")
        print(f"Killed mutations: {killed}")
        print(f"Survived mutations: {survived}")
        print(f"Mutation score: {mutation_score:.2f}%")
        print("\nDetailed Results:")
        
        for result in self.results:
            status = "KILLED" if result['killed'] else "SURVIVED"
            print(f"\nMutation {result['mutation_id']} - {status}")
            print(f"Description: {result['description']}")
            
            if not result['killed']:
                print("This mutation survived - tests didn't detect the change!")
                
        print("\nSummary:")
        print(f"Mutation score: {mutation_score:.2f}%")
        if mutation_score < 80:
            print("Warning: Mutation score is below 80%. Consider adding more test cases.")
        else:
            print("Good job! Your tests are effective at catching mutations.")

def main():
    parser = argparse.ArgumentParser(description='Run mutation testing for Solidity contracts using Hardhat')
    parser.add_argument('contract', help='Path to the Solidity contract to test')
    parser.add_argument('--test-path', default='test', help='Path to test directory (default: test)')
    parser.add_argument('--project-root', default='.', help='Path to Hardhat project root (default: current directory)')
    parser.add_argument('--max-mutations', type=int, default=10, help='Maximum number of mutations to generate (default: 10)')
    
    args = parser.parse_args()
    
    tester = MutationTester(
        contract_path=args.contract,
        test_path=args.test_path,
        project_root=args.project_root
    )
    
    tester.run_mutation_test(max_mutations=args.max_mutations)

if __name__ == '__main__':
    main()