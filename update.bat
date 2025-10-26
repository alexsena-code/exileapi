@echo off
setlocal

:: -----------------------------------------------------------------
:: VARIAVEIS DE CONFIGURACAO
:: -----------------------------------------------------------------
:: O local onde o repositório ja existe
set "RepoDir=C:\POE\ExileApi-Compiled"
:: O nome da branch principal
set "MainBranch=master"

echo Iniciando atualizacao forcada em "%RepoDir%"...
echo.

:: 1. Entra no diretório do repositório
cd /d "%RepoDir%"

:: Verifica se conseguiu entrar no diretório
if %errorLevel% NEQ 0 (
    echo ERRO: Nao foi possivel acessar o diretorio "%RepoDir%".
    echo Verifique se o caminho esta correto e o repositorio ja foi clonado.
    pause
    goto :eof
)

echo Acessando repositorio...
echo.

:: 2. Busca todas as atualizações do servidor remoto
echo (1/2) Buscando atualizacoes (git fetch)...
git fetch origin

:: 3. Força o repositório local a ser uma cópia exata do remoto
:: (Descarta quaisquer alterações locais e atualiza para a versão da 'origin')
echo (2/2) Resetando para a versao mais recente (git reset --hard)...
git reset --hard origin/%MainBranch%

echo.
echo ATUALIZACAO CONCLUIDA! O repositorio esta na ultima versao.
echo.
pause
endlocal