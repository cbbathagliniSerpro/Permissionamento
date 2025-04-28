import os
import re
import subprocess
import difflib
from concurrent.futures import ThreadPoolExecutor

# Configurações
CONTRACT_PATH = "contracts/OrganizationImpl.sol"  # Caminho do contrato original
MUTANT_DIR = "mutants"  # Pasta para armazenar mutantes gerados
LOG_DIR = "logs"  # Pasta para armazenar logs dos mutantes
TEST_COMMAND = "npx hardhat test"  # Comando para rodar os testes

if not os.path.exists(LOG_DIR):
    os.makedirs(LOG_DIR)

# Funções auxiliares
def create_mutant(original_code, mutation, mutant_path):
    """Gera um contrato mutante e salva no diretório especificado."""
    with open(mutant_path, "w") as mutant_file:
        mutant_file.write(mutation)

def show_diff(original_code, mutant_code):
    """Exibe a diferença entre o código original e o mutante."""
    original_lines = original_code.splitlines()
    mutant_lines = mutant_code.splitlines()
    diff = difflib.unified_diff(original_lines, mutant_lines, fromfile="Original", tofile="Mutant", lineterm="")
    return "\n".join(diff)

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
        (r"require\((.*?)\);", r"require(!\1);"),
        (r"\btrue\b", "false"),
        (r"\bfalse\b", "true"),
        (r"\+", "-"),
        (r"-", "+")
    ]
    
    for pattern, replacement in mutations:
        for match in re.finditer(pattern, original_code):
            original_line = original_code[original_code.rfind('\n', 0, match.start()) + 1:original_code.find('\n', match.end())]
            mutant_code = original_code[:match.start()] + re.sub(pattern, replacement, match.group(0)) + original_code[match.end():]
            mutants.append((original_line, re.sub(pattern, replacement, match.group(0)), mutant_code))
    
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

def log_result(mutant_number, diff, original_line, mutant_code_snippet, detected):
    """Salva o resultado do mutante em um arquivo de log."""
    status = "detectado" if detected else "sobreviveu"
    log_path = os.path.join(LOG_DIR, f"Mutant_{mutant_number}_log.txt")
    with open(log_path, "w") as log_file:
        log_file.write(f"=== Mutante {mutant_number} ===\n")
        log_file.write(f"Linha original: {original_line.strip()}\n")
        log_file.write(f"Mutante inserido: {mutant_code_snippet}\n")
        log_file.write(diff + "\n")
        log_file.write(f"Resultado dos testes: {status}\n")

def process_mutant(original_code, mutant_info, mutant_number):
    """Processa um único mutante: cria, roda os testes e loga o resultado."""
    original_line, mutant_code_snippet, mutant = mutant_info
    mutant_path = os.path.join(MUTANT_DIR, f"Mutant_{mutant_number}.sol")
    create_mutant(original_code, mutant, mutant_path)
    diff = show_diff(original_code, mutant)
    detected = run_tests()
    log_result(mutant_number, diff, original_line, mutant_code_snippet, detected)
    print(f"\n=== Mutante {mutant_number} ===")
    print(f"Linha original: {original_line.strip()}")
    print(f"Mutante inserido: {mutant_code_snippet}")
    print(f"[{'✔️' if detected else '❌'}] Mutante {mutant_number} {'detectado' if detected else 'sobreviveu'}.")
    return detected

def main():
    if not os.path.exists(CONTRACT_PATH):
        print(f"Erro: Arquivo {CONTRACT_PATH} não encontrado.")
        return

    # Ler o contrato original
    with open(CONTRACT_PATH, "r") as file:
        original_code = file.read()

    # Gerar mutantes
    mutants = generate_mutants(original_code)
    mutant_number = get_next_mutant_number()
    detected_count = 0

    # Processar mutantes em paralelo
    with ThreadPoolExecutor() as executor:
        results = executor.map(lambda args: process_mutant(*args), [(original_code, mutant_info, i) for i, mutant_info in enumerate(mutants, start=mutant_number)])
        detected_count = sum(results)

    # Exibir relatório final
    total_mutants = len(mutants)
    print(f"\n✅ Processo de teste de mutação concluído!")
    print(f"Total de mutantes: {total_mutants}")
    print(f"Detectados: {detected_count}")
    print(f"Sobreviventes: {total_mutants - detected_count}")
    print(f"Taxa de detecção: {(detected_count / total_mutants) * 100:.2f}%\n")

if __name__ == "__main__":
    main()
