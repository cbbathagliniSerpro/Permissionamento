import os
import re
import subprocess
import difflib

# Configurações
CONTRACT_PATH = "contracts/AccountRulesV2Impl.sol"  # Caminho do contrato original
MUTANT_DIR = "mutants"  # Pasta para armazenar mutantes gerados
TEST_COMMAND = "npx hardhat test"  # Comando para rodar os testes

def create_mutant(original_code, mutation, mutant_path):
    """Gera um contrato mutante e salva no diretório especificado."""
    with open(mutant_path, "w") as mutant_file:
        mutant_file.write(mutation)

def show_diff(original_code, mutant_code):
    """Exibe a diferença entre o código original e o mutante."""
    original_lines = original_code.splitlines()
    mutant_lines = mutant_code.splitlines()
    diff = difflib.unified_diff(original_lines, mutant_lines, fromfile="Original", tofile="Mutant", lineterm="")
    print("\n".join(diff))

def run_tests():
    """Executa os testes e retorna True se os testes falharem (mutante detectado)."""
    try:
        result = subprocess.run(TEST_COMMAND, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return result.returncode != 0
    except subprocess.CalledProcessError:
        return True  # Se os testes falharem, consideramos o mutante detectado

def generate_mutants(original_code):
    """Gera mutantes a partir do código original."""
    mutants = []
    mutations = [
        (r"==", "!="),
        (r">=", ">"),
        (r"<=", "<"),
        (r"require\((.*?)\);", r"require(!(\1));"),
    ]
    
    for pattern, replacement in mutations:
        for match in re.finditer(pattern, original_code):
            mutant_code = original_code[:match.start()] + re.sub(pattern, replacement, match.group(0)) + original_code[match.end():]
            mutants.append(mutant_code)
    
    return mutants

def get_next_mutant_number():
    """Calcula o próximo número de mutante para evitar sobrescrita."""
    if not os.path.exists(MUTANT_DIR):
        os.makedirs(MUTANT_DIR)
        return 1
    existing_mutants = [f for f in os.listdir(MUTANT_DIR) if f.startswith("Mutant_") and f.endswith(".sol")]
    if not existing_mutants:
        return 1
    existing_numbers = [int(f.split("_")[1].split(".")[0]) for f in existing_mutants]
    return max(existing_numbers) + 1

def main():
    if not os.path.exists(CONTRACT_PATH):
        print(f"Erro: Arquivo {CONTRACT_PATH} não encontrado.")
        return

    # Ler o contrato original
    with open(CONTRACT_PATH, "r") as file:
        original_code = file.read()

    # Gerar e testar mutantes
    mutants = generate_mutants(original_code)
    mutant_number = get_next_mutant_number()
    
    for mutant in mutants:
        mutant_path = os.path.join(MUTANT_DIR, f"Mutant_{mutant_number}.sol")
        create_mutant(original_code, mutant, mutant_path)
        
        print(f"\n=== Mutante {mutant_number} ===")
        show_diff(original_code, mutant)
        
        # Substituir contrato original pelo mutante
        with open(CONTRACT_PATH, "w") as file:
            file.write(mutant)
        
        # Executar os testes
        if run_tests():
            print(f"[✔️] Mutante {mutant_number} detectado pelos testes!")
        else:
            print(f"[❌] Mutante {mutant_number} sobreviveu aos testes.")
        
        mutant_number += 1
    
    # Restaurar o contrato original
    with open(CONTRACT_PATH, "w") as file:
        file.write(original_code)
    print("\n✅ Processo de teste de mutação concluído!")

if __name__ == "__main__":
    main()
