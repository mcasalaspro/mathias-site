@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Ver o site do Mathias na sua maquina

echo(
echo  ============================================
echo    VER O SITE NA SUA MAQUINA
echo  ============================================
echo(
echo  Abrir o index.html com dois cliques mostra o site pela metade:
echo  o navegador nao deixa uma pagina em file:// ler os arquivos de
echo  dados. Este atalho sobe um servidor local e resolve isso.
echo(

py -3 --version >nul 2>&1
if not errorlevel 1 goto usar_py

python --version >nul 2>&1
if not errorlevel 1 goto usar_python

npx --version >nul 2>&1
if not errorlevel 1 goto usar_npx

goto sem_ferramenta

:usar_py
echo  Servidor no ar em  http://localhost:8000
echo  Para encerrar, feche esta janela ou tecle Ctrl+C.
echo(
start "" http://localhost:8000
py -3 -m http.server 8000
goto fim

:usar_python
echo  Servidor no ar em  http://localhost:8000
echo  Para encerrar, feche esta janela ou tecle Ctrl+C.
echo(
start "" http://localhost:8000
python -m http.server 8000
goto fim

:usar_npx
echo  Servidor no ar. O endereco aparece abaixo em alguns segundos.
echo  Para encerrar, feche esta janela ou tecle Ctrl+C.
echo(
npx --yes serve -l 8000
goto fim

:sem_ferramenta
echo  [!] Nao encontrei Python nem Node neste computador.
echo(
echo      Opcao 1 — instalar o Python (leve, 3 minutos):
echo        https://www.python.org/downloads/
echo        Na primeira tela, marque "Add python.exe to PATH".
echo        Depois rode este arquivo de novo.
echo(
echo      Opcao 2 — nem instalar nada:
echo        publique com o PUBLICAR.bat e veja o site no ar.
echo        No GitHub e na Cloudflare tudo funciona sem servidor local.
echo(
pause

:fim
