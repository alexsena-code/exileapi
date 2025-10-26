@echo off
setlocal

:: -----------------------------------------------------------------
:: 1. VERIFICAR SE ESTA SENDO EXECUTADO COMO ADMINISTRADOR
:: -----------------------------------------------------------------
echo Verificando privilegios de administrador...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Sucesso: Script esta sendo executado como Administrador.
) else (
    echo ERRO: Este script precisa ser executado como Administrador.
    echo Clique com o botao direito no arquivo .bat e escolha "Executar como administrador".
    pause
    goto :eof
)
echo.

:: -----------------------------------------------------------------
:: 2. INSTALAR DRIVERS COM WINGET
:: -----------------------------------------------------------------
echo Iniciando instalacao de drivers via winget...
echo.


:: Substitua os IDs de exemplo abaixo
winget install Microsoft.DotNet.SDK.8
winget install -e --id Microsoft.VCRedist.2015+.x64
winget install Microsoft.DotNet.DesktopRuntime.8
winget install --id=Git.Git  -e

echo.
echo Instalacao de drivers concluida.
echo.

:: -----------------------------------------------------------------
:: 3. CRIAR USUARIO "bot" COM SENHA "123"
:: -----------------------------------------------------------------
echo Criando usuario 'bot'...
net user bot 123 /add

:: Verifica se o usuario foi criado com sucesso
if %errorLevel% == 0 (
    echo Usuario 'bot' criado com sucesso.
) else (
    echo ERRO: Nao foi possivel criar o usuario 'bot'. Ele ja pode existir.
)
echo.

:: -----------------------------------------------------------------
:: 4. CRIAR PASTA E RESTRINGIR PERMISSOES
:: -----------------------------------------------------------------
set "PastaRestrita=C:\POE"
echo Criando pasta em %PastaRestrita%...
mkdir "%PastaRestrita%"

echo Aplicando restricoes de permissao para o usuario 'bot'...
:: /deny: Nega permissões
:: bot: Para o usuário "bot"
:: (OI): Herança de Objeto (arquivos herdarão esta regra)
:: (CI): Herança de Contêiner (subpastas herdarão esta regra)
:: F: Acesso Total (Full Control)
icacls "%PastaRestrita%" /deny bot:(OI)(CI)F

echo Permissoes aplicadas. O usuario 'bot' nao tem acesso a %PastaRestrita%.
echo.

:: -----------------------------------------------------------------
:: 5. COPIAR ARQUIVOS ".bat" (*** MUDANCA AQUI ***)
:: -----------------------------------------------------------------
echo Copiando 'poe.bat' para %PastaRestrita%...
:: %~dp0 e o diretorio onde este script .bat esta sendo executado.
:: Garante que o poe.bat seja encontrado se estiver na mesma pasta do script.
if exist "%~dp0poe.bat" (
    copy "%~dp0poe.bat" "%PastaRestrita%\"
    echo 'poe.bat' copiado com sucesso.
) else (
    echo ERRO: Nao foi possivel encontrar 'poe.bat' no diretorio do script.
)
echo.

echo Copiando 'update.bat' para %PastaRestrita%...
:: %~dp0 e o diretorio onde este script .bat esta sendo executado.
:: Garante que o poe.bat seja encontrado se estiver na mesma pasta do script.
if exist "%~dp0update.bat" (
    copy "%~dp0update.bat" "%PastaRestrita%\"
    echo 'update.bat' copiado com sucesso.
) else (
    echo ERRO: Nao foi possivel encontrar 'update.bat' no diretorio do script.
)
echo.

:: -----------------------------------------------------------------
:: 6. CLONAR O REPOSITORIO DO GITHUB
:: -----------------------------------------------------------------
echo Baixando o repositorio 'ExileApi-Compiled'...
:: Define o local de clone para dentro da pasta restrita
set "CloneLocal=%PastaRestrita%\ExileApi-Compiled"

:: Clona o repositório
git clone https://github.com/exApiTools/ExileApi-Compiled "%CloneLocal%"

if %errorLevel% == 0 (
    echo Repositorio clonado com sucesso para "%CloneLocal%"
) else (
    echo ERRO: Falha ao clonar o repositorio. Verifique se o Git esta instalado e no PATH.
)
echo.

:: -----------------------------------------------------------------
:: CONCLUSAO
:: -----------------------------------------------------------------
echo Script concluido!
pause
endlocal