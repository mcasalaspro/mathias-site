@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
title Publicar o site do Mathias

echo(
echo  ============================================
echo    PUBLICAR O SITE DO MATHIAS
echo  ============================================
echo(

rem ---------- 1. localizar o Git ----------
rem O instalador nem sempre poe o Git no PATH. Procuramos nos lugares padrao
rem (instalacao para todos os usuarios e instalacao so para o seu usuario) e,
rem achando, acrescentamos a pasta ao PATH desta janela. Dai em diante o resto
rem do arquivo chama "git" normalmente.
where git >nul 2>&1
if not errorlevel 1 goto git_ok

set "P86=%ProgramFiles(x86)%"
set "GITDIR="
if exist "%ProgramFiles%\Git\cmd\git.exe"          set "GITDIR=%ProgramFiles%\Git\cmd"
if not defined GITDIR if exist "%P86%\Git\cmd\git.exe" set "GITDIR=%P86%\Git\cmd"
if not defined GITDIR if exist "%LOCALAPPDATA%\Programs\Git\cmd\git.exe" set "GITDIR=%LOCALAPPDATA%\Programs\Git\cmd"
if not defined GITDIR if exist "C:\Program Files\Git\cmd\git.exe" set "GITDIR=C:\Program Files\Git\cmd"
if not defined GITDIR goto sem_git

set "PATH=%GITDIR%;%PATH%"
echo  Git encontrado em  %GITDIR%
echo(

:git_ok

rem ---------- 2. identidade do Git ----------
set "GITNOME="
for /f "delims=" %%A in ('git config --global user.name 2^>nul') do set "GITNOME=%%A"
if defined GITNOME goto identidade_ok

echo  Primeira vez neste computador. O Git precisa saber quem assina as alteracoes.
echo(
set /p "NOME=   Seu nome: "
set /p "EMAIL=   Seu e-mail do GitHub: "
if "!NOME!"=="" goto cancelado
git config --global user.name "!NOME!"
git config --global user.email "!EMAIL!"
echo(
echo  Anotado.
echo(

:identidade_ok

rem ---------- 3. o repositorio ja esta conectado? ----------
set "PRIMEIRAVEZ="
if exist ".git" goto repo_ok

set "PRIMEIRAVEZ=1"
echo  Este e o primeiro envio. Antes de continuar, crie o repositorio no GitHub:
echo(
echo     1. Abra  https://github.com/new
echo     2. Repository name:  mathias-site
echo     3. Marque  Public
echo     4. NAO marque "Add a README file" — o repositorio precisa nascer vazio
echo     5. Clique em  Create repository
echo     6. Copie a URL que aparece na tela seguinte, algo como
echo        https://github.com/SEU-USUARIO/mathias-site.git
echo(
set /p "URL=   Cole a URL aqui e tecle Enter: "
if "!URL!"=="" goto cancelado

git init -q
git branch -M main
git remote add origin "!URL!"
echo(
echo  Repositorio conectado.
echo(

:repo_ok

rem ---------- 4. ha algo para enviar? ----------
echo  Verificando o que mudou...
git add -A

set "MUDOU="
for /f "delims=" %%A in ('git status --porcelain 2^>nul') do set "MUDOU=1"
if not defined MUDOU goto nada_mudou

echo(
git status --short
echo(

set "MSG="
set /p "MSG=   Descreva a mudanca (ou so tecle Enter): "
if "!MSG!"=="" set "MSG=Atualiza o site"

git commit -q -m "!MSG!"

rem ---------- 5. enviar ----------
echo(
echo  Enviando para o GitHub...
echo  Se abrir uma janela pedindo login, entre com a sua conta do GitHub.
echo(

git push -u origin main
if errorlevel 1 goto tentar_juntar
goto sucesso

:tentar_juntar
echo(
echo  O GitHub tem algo que nao esta nesta pasta. Juntando as duas versoes...
echo(
git pull --rebase origin main
if errorlevel 1 goto erro_push
git push -u origin main
if errorlevel 1 goto erro_push
goto sucesso

rem ============================================================
:sucesso
echo(
echo  ============================================
echo    PRONTO. Arquivos enviados.
echo  ============================================
echo(
for /f "delims=" %%A in ('git remote get-url origin 2^>nul') do set "REMOTO=%%A"
echo    Repositorio:  !REMOTO!
echo(
if not defined PRIMEIRAVEZ goto fim_ok

echo    FALTA UM PASSO, so desta primeira vez:
echo(
echo     1. Abra o repositorio no GitHub
echo     2. Va em  Settings  ^>  Pages
echo     3. Em "Source", escolha  Deploy from a branch
echo     4. Branch:  main   /  Pasta:  / (root)   e clique em Save
echo     5. Espere um minuto e recarregue a pagina: o endereco do site aparece la
echo(
echo    Das proximas vezes, basta rodar este arquivo de novo.
echo(
goto fim

:fim_ok
echo    O site publicado se atualiza em cerca de um minuto.
echo(
goto fim

rem ============================================================
:nada_mudou
echo(
echo  Nada mudou desde o ultimo envio. Nao ha o que publicar.
echo(
goto fim

:sem_git
echo  [!] Nao encontrei o Git neste computador.
echo(
echo      Procurei no PATH e nestas pastas:
echo        %ProgramFiles%\Git\cmd\git.exe
echo        %LOCALAPPDATA%\Programs\Git\cmd\git.exe
echo(
echo      Se o Git nao estiver instalado:
echo        1. Baixe em  https://git-scm.com/download/win
echo        2. Instale aceitando todas as opcoes padrao
echo        3. Feche esta janela e rode este arquivo de novo
echo(
echo      Se ele estiver instalado em outro lugar, abra este arquivo no Bloco
echo      de Notas e acrescente o caminho na lista do topo.
echo(
goto fim

:erro_push
echo(
echo  [!] O envio falhou. Causas mais comuns:
echo(
echo      - A URL do repositorio esta errada.
echo        Confira com:  git remote -v
echo        Para corrigir:  git remote set-url origin URL-CERTA
echo(
echo      - O login do GitHub foi recusado ou cancelado.
echo        Rode este arquivo de novo e complete o login no navegador.
echo(
echo      - O repositorio foi criado com README.
echo        Nesse caso o script ja tentou juntar as versoes e nao conseguiu.
echo        Apague o repositorio no GitHub, crie outro vazio e rode de novo.
echo(
goto fim

:cancelado
echo(
echo  Cancelado. Nada foi enviado.
echo(

:fim
echo(
pause
endlocal
