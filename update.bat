@echo off
setlocal

:: -----------------------------------------------------------------
:: VARIAVEIS DE CONFIGURACAO
:: -----------------------------------------------------------------
:: O local onde o repositório foi clonado no script anterior
set "RepoDir=C:\Repo\ExileApi-Compiled"
:: A URL do repositório
set "RepoUrl=https://github.com/exApiTools/ExileApi-Compiled.git"
:: O nome da branch principal (geralmente 'main' ou 'master')
set "MainBranch=main"

:: -----------------------------------------------------------------
:: 1. VERIFICAR SE ESTA SENDO EXECUTADO COMO ADMINISTRADOR
:: -----------------------------------------------------------------
echo Verificando privilegios de administrador...
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ERRO: Este script precisa ser executado como Administrador.
    echo Clique com o botao direito no arquivo .bat e escolha "Executar como administrador".
    pause
    goto :eof
)
echo Sucesso: Executando como Administrador.
echo.

:: -----------------------------------------------------------------
:: 2. VERIFICAR SE O GIT ESTA INSTALADO
:: -----------------------------------------------------------------
git --version >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ERRO: O Git nao foi encontrado no seu sistema.
    echo Por favor, instale o Git (https://git-scm.com/downloads) e adicione-o ao PATH.
    pause
    goto :eof
)
echo Git encontrado.
echo.

:: -----------------------------------------------------------------
:: 3. LOGICA PRINCIPAL: ATUALIZAR OU CLONAR
:: -----------------------------------------------------------------

:: Verifica se o diretório .git existe, o que confirma que é um repositório
if exist "%RepoDir%\.git" (
    echo O repositorio ja existe em "%RepoDir%".
    echo Iniciando atualizacao forcada...
    
    :: Entra no diretório do repositório
    cd /d "%RepoDir%"
    
    :: 1. Busca todas as atualizações do servidor remoto (origin)
    echo (1/3) Buscando atualizacoes (git fetch)...
    git fetch origin
    
    :: 2. Força o repositório local a ser uma cópia exata do remoto
    :: Isso descarta todas as alterações locais (a forma mais segura de atualizar)
    echo (2/3) Resetando para a versao mais recente (git reset --hard)...
    git reset --hard origin/%MainBranch%
    
    :: 3. Limpa quaisquer arquivos extras que não façam parte do repositório
    echo (3/3) Limpando arquivos locais extras (git clean)...
    git clean -fd
    
    echo.
    echo ATUALIZACAO CONCLUIDA! Repositorio esta na ultima versao.

) else (
    echo O repositorio nao foi encontrado em "%RepoDir%".
    echo Iniciando clone do zero...

    :: Se a pasta existir, mas não for um repo (ex: clone falhou antes),
    :: vamos removê-la para garantir um clone limpo.
    if exist "%RepoDir%" (
        echo Removendo diretorio antigo/incompleto...
        rmdir /s /q "%RepoDir%"
    )
    
    :: Clona o repositório
    git clone "%RepoUrl%" "%RepoDir%"
    
    if %errorLevel% == 0 (
        echo CLONE CONCLUIDO! Repositorio baixado com sucesso.
    ) else (
        echo ERRO: Falha ao clonar o repositorio. Verifique a URL e sua conexao.
    )
)
echo.

:: -----------------------------------------------------------------
:: CONCLUSAO
:: -----------------------------------------------------------------
echo Script de atualizacao finalizado.
pause
endlocal