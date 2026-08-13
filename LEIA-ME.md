# Site do Mathias — publicar e manter

HTML puro, sem WordPress, sem Elementor, sem framework, sem build. Feito para viver num
repositório do GitHub e ser servido pela Cloudflare.

**A regra mais importante: você não precisa abrir o `index.html` para atualizar o site.**
Tudo que muda está em `dados/`, em três arquivos de texto simples.

```
CONFIGURAR-GIT.bat            prepara o Git na sua máquina (uma vez só)
PUBLICAR.bat                  envia tudo para o GitHub (Windows)
VER-LOCAL.bat                 abre o site na sua máquina para conferir
index.html                    o site (não precisa ser editado)
dados/conteudo.json           números, conquistas, imprensa, contato
dados/videos.json             lista de vídeos do YouTube
dados/galeria.json            legendas das fotos (gerado sozinho)
dados/hero.json               imagens do topo (gerado sozinho)
dados/idiomas/                pt.json, en.json, it.json
assets/                       imagens fixas
assets/hero/                  imagens de fundo da primeira dobra
assets/galeria/               é só jogar fotos aqui
assets/loja/                  fotos dos produtos
assets/logo-mc.png            o logo, usado no topo e no rodapé
.github/workflows/galeria.yml a rotina que indexa a pasta de fotos
_headers                      regras de cache da Cloudflare
```

---

## 1. Publicar (Windows, com o PUBLICAR.bat)

### Passo 0 — instalar o Git, uma vez só

O Git é o programa que leva os arquivos daqui até o GitHub.

**Versão recomendada: 2.55.0(4)**, arquivo `Git-2.55.0.4-64-bit.exe`. Não é capricho: essa
versão corrige a CVE-2026-62960, uma falha em que um servidor malicioso podia fazer o Windows
autenticar via NTLM sem você perceber e vazar o hash da sua senha. A 2.55.0(3) já tinha
corrigido estouros de memória no gerenciador de credenciais. Se for instalar hoje, instale
essa.

**Caminho 1 — instalador.** Baixe em <https://git-scm.com/download/win>, clique em
*Click here to download*, e rode o `Git-2.55.0.4-64-bit.exe`.

**Caminho 2 — uma linha.** Abra o Prompt de Comando e cole:

```
winget install --id Git.Git -e --source winget
```

#### As telas do instalador que importam

São umas quinze telas. Em quase todas, *Next* resolve. Estas quatro merecem atenção:

| Tela | O que escolher | Por quê |
|---|---|---|
| **Choosing the default editor** | **Use Notepad as Git's default editor** | O padrão é o Vim, um editor de terminal do qual é famosamente difícil sair. |
| **Adjusting the name of the initial branch** | **Override → `main`** | É o nome que o GitHub usa. Com o padrão antigo (`master`), o envio falha. |
| **Adjusting your PATH environment** | **Git from the command line and also from 3rd-party software** (a do meio, já marcada) | Sem isso o `PUBLICAR.bat` não encontra o Git. |
| **Choose a credential helper** | **Git Credential Manager** (já marcada) | É o que abre o login do GitHub no navegador e guarda a sessão. Sem ele, o Git pede senha toda vez — e o GitHub não aceita mais senha. |

Nas demais, o padrão está certo: *Checkout Windows-style, commit Unix-style line endings*,
*Use bundled OpenSSH*, *Use the OpenSSL library*, *Use MinTTY*, *Default (fast-forward or
merge)* e *Enable file system caching*. Não marque nada em *Configuring experimental options*.

Para conferir depois, abra o Prompt de Comando e digite `git --version`. Deve responder
`git version 2.55.0.windows.4`.

Para atualizar no futuro: `git update-git-for-windows`.

### Passo 0b — configurar o Git

Dê dois cliques em **CONFIGURAR-GIT.bat**. Ele pergunta seu nome e e-mail (use o mesmo da
conta do GitHub) e aplica de uma vez tudo o que evita dor de cabeça depois:

| Configuração | Para quê |
|---|---|
| `user.name` e `user.email` | Assinam cada alteração no histórico. |
| `init.defaultBranch main` | Novos repositórios já nascem com a branch certa. |
| `core.editor notepad` | Um commit sem mensagem abre o Bloco de Notas, não o Vim. |
| `credential.helper manager` | Guarda o login do GitHub com segurança no Windows. |
| `core.autocrlf true` | Quebra de linha Windows no seu disco, Unix no repositório. |
| `pull.rebase false` | Some com o aviso de "divergent branches". |
| `core.quotepath false` | Mostra acentos nos nomes de arquivo em vez de `\303\247`. |
| `core.longpaths true` | Evita o limite antigo de caminho longo do Windows. |
| `push.default simple` | Envia só a branch atual, nunca todas sem querer. |

Tudo isso vai parar num arquivo de texto em `C:\Users\SEU-USUARIO\.gitconfig`. Dá para abrir
e conferir quando quiser.

Se preferir digitar à mão, são estes comandos:

```bash
git config --global user.name "Seu Nome"
git config --global user.email "voce@exemplo.com"
git config --global init.defaultBranch main
git config --global core.editor "notepad"
git config --global credential.helper manager
git config --global core.autocrlf true
git config --global pull.rebase false
git config --global core.quotepath false
git config --global core.longpaths true
git config --global push.default simple
```

### Passo 1 — criar a conta e o repositório

1. Se ainda não tiver conta, crie em <https://github.com/signup> (grátis).
2. Abra <https://github.com/new>.
3. **Repository name:** `mathias-site`
4. Marque **Public**. Precisa ser público para o GitHub Pages funcionar de graça.
5. **Não marque** "Add a README file". O repositório precisa nascer vazio.
6. Clique em **Create repository**.
7. Na tela seguinte, copie a URL — algo como
   `https://github.com/SEU-USUARIO/mathias-site.git`

### Passo 2 — rodar o PUBLICAR.bat

Dê dois cliques em **PUBLICAR.bat**, dentro desta pasta. Na primeira vez ele pergunta três
coisas:

- **Seu nome e e-mail** — é a assinatura que fica no histórico de alterações.
- **A URL do repositório** — cole a que você copiou no passo 1.

Depois disso, o Git Credential Manager abre uma janela pedindo para entrar na sua conta do
GitHub — escolha **Sign in with your browser**, autorize e feche a aba. Os arquivos sobem. A
sessão fica guardada no Gerenciador de Credenciais do Windows, então da segunda vez em diante
o login não é mais pedido.

> **Não use senha.** O GitHub não aceita mais senha em envios desde 2021. Se alguma tela pedir
> senha em vez de abrir o navegador, cancele e confira se o `credential.helper` está como
> `manager` — o `CONFIGURAR-GIT.bat` resolve isso.

> Se o Windows avisar que "protegeu o computador", clique em **Mais informações → Executar
> assim mesmo**. É o aviso padrão para qualquer arquivo `.bat` baixado da internet.

### Passo 3 — ligar o GitHub Pages, uma vez só

1. Abra o repositório no GitHub.
2. **Settings → Pages**.
3. Em *Source*, escolha **Deploy from a branch**.
4. Branch: **main**. Pasta: **/ (root)**. Clique em **Save**.
5. Espere um minuto e recarregue: o endereço do site aparece no topo da página, no formato
   `https://SEU-USUARIO.github.io/mathias-site/`.

### Nas próximas vezes

Edite o que quiser, dê dois cliques em **PUBLICAR.bat**, descreva a mudança (ou só tecle
Enter) e pronto. O site no ar se atualiza em cerca de um minuto.

Se nada tiver mudado desde o último envio, o script avisa e não faz nada.

> **Por que usar o .bat em vez de arrastar os arquivos no site do GitHub?** Porque o
> arrastar-e-soltar ignora arquivos que começam com ponto — e este projeto tem dois que são
> essenciais: `.nojekyll` (sem ele o GitHub processa o site com Jekyll e alguns arquivos
> somem) e `.github/` (a rotina que indexa as fotos da galeria). O `.bat` envia tudo.

### Se preferir fazer pelo terminal

Os quatro comandos que o `.bat` executa por baixo, caso um dia queira rodar à mão:

```bash
git init
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/mathias-site.git
git add -A && git commit -m "Publica o site" && git push -u origin main
```

### Domínio próprio pela Cloudflare

Duas formas, ambas gratuitas:

**A) Cloudflare Pages (recomendada).** Em *Workers & Pages → Create → Pages → Connect to Git*,
aponte para o repositório. Build command: deixe vazio. Output directory: `/`. Cada push
publica sozinho, o `_headers` passa a valer e você ganha o CDN da Cloudflare.

**B) GitHub Pages + DNS da Cloudflare.** Em *Settings → Pages → Custom domain*, coloque
`www.mathiascasalaspro.com.br` (isso cria um arquivo `CNAME` no repositório). Na Cloudflare,
crie um registro `CNAME` de `www` para `SEU-USUARIO.github.io`. Nessa opção o `_headers` é
ignorado — configure o cache em *Rules → Cache Rules* com os mesmos valores do arquivo.

Em qualquer das duas, marque **Enforce HTTPS**.

---

## 1b. Ver o site na sua máquina antes de publicar

**Abrir o `index.html` com dois cliques funciona só pela metade.** Por segurança, todo
navegador proíbe uma página aberta em `file://` de ler arquivos da própria pasta. Ou seja: os
`dados/*.json` não carregam. O site não quebra — ele cai nas cópias de reserva que estão
dentro do próprio HTML —, mas o que você vê pode não refletir as suas edições nos JSON.

Para ver o site de verdade, dê dois cliques em **VER-LOCAL.bat**. Ele sobe um servidor na
pasta e abre o navegador sozinho em `http://localhost:8000`. Para encerrar, feche a janela
preta.

O script usa o Python ou o Node, se algum dos dois estiver instalado. Se não houver nenhum,
ele avisa e explica as opções — mas nesse caso o mais simples é publicar com o
`PUBLICAR.bat` e conferir o site já no ar.

No macOS ou Linux, o equivalente é `python3 -m http.server 8000` dentro da pasta.

Quando o site estiver publicado (GitHub Pages ou Cloudflare), nada disso é necessário: lá os
JSON carregam normalmente e sempre vencem as cópias de reserva.

---

## 2. Atualizar o conteúdo

Dá para editar direto no site do GitHub: abra o arquivo, clique no lápis, salve. O site se
atualiza sozinho em cerca de um minuto.

### Números, conquistas, imprensa → `dados/conteudo.json`

```json
"numeros": [
  { "valor": 2341, "rotulo": "Rating FIDE" }
],
"caminho": {
  "ratingAtual": 2341,
  "normasFeitas": 1,
  "metaValor": 60000,
  "arrecadado": 12500,
  "apoiadores": 0
}
```

Subiu o rating? Troque `2341` nos dois lugares e salve. A régua, as casas de norma e a barra
de meta se redesenham sozinhas.

Nova conquista? Acrescente uma linha no topo da lista `conquistas`:

```json
{ "ano": "2027", "texto": "...", "local": "Cidade, País", "selo": "Norma de MI", "tipo": "fide" }
```

`tipo` aceita `"inedito"` (selo dourado cheio), `"fide"` (selo contornado) ou nada. `local` e
`selo` são opcionais.

### Vídeos → `dados/videos.json`

Cole a URL e pronto. Aceita qualquer formato do YouTube — `watch?v=`, `youtu.be/`, `/shorts/`,
`/embed/`. Os 18 que você mandou já estão lá. O primeiro da lista aparece grande no mosaico;
os outros preenchem a grade, que se fecha sozinha para nunca sobrar uma miniatura solta na
última linha.

Não precisam ser do canal do Mathias: qualquer vídeo público entra, e um vídeo de canal grande
falando dele vale mais para patrocinador do que um vídeo do próprio Mathias.

### Imagem do topo → `assets/hero/`

A primeira dobra usa uma foto de fundo que ocupa a tela inteira, com um degradê azul por cima
para o texto continuar legível. **A cada visita o site sorteia uma das imagens da pasta** e,
depois, troca para a seguinte a cada 7 segundos, com transição suave.

Para testar outras fotos, largue os arquivos em `assets/hero/` e faça o commit — a mesma
rotina do GitHub indexa a pasta. O intervalo e as legendas ficam em `dados/hero.json`:

```json
{
  "intervaloSegundos": 7,
  "fotos": [
    { "arquivo": "01_floripa-blitz-abertura.jpg", "credito": "Brazil Chess Series · Floripa 2026" }
  ]
}
```

O `credito` aparece pequeno no canto inferior e acompanha a troca de imagem.

**Use fotos horizontais.** Uma foto vertical esticada para a largura da tela fica muito
ampliada — as duas que estão lá agora servem de teste, mas o ideal são imagens largas, de 1600
a 2400px, com espaço vazio do lado esquerdo, que é onde o texto fica.

Quem tem "reduzir movimento" ligado no sistema vê uma imagem fixa, sem troca.

### Fotos da galeria → é só jogar na pasta

Arraste as imagens para `assets/galeria/` e faça o commit. Uma rotina do GitHub roda sozinha,
lê a pasta e reescreve `dados/galeria.json`. **Você não precisa mexer em nada além de largar o
arquivo lá.**

Se nomear no padrão `2026-08_leca-chess-open_primeira-norma.jpg`, a legenda já sai preenchida
como *"Leça Chess Open · Primeira norma"*. Depois é só ajustar o texto no `dados/galeria.json`
— a rotina preserva as legendas que você escrever.

Uma foto vira uma faixa larga. Duas ou mais viram uma tira que rola para o lado.

Fotos grandes deixam o site lento. Antes de subir, redimensione para no máximo 1600px de
largura e salve em JPG com qualidade 80.

---

## 3. A contagem de visualizações

A seção **Alcance** mostra o total de views somado de todos os vídeos da lista, arredondado
**sempre para baixo** — 517.430 vira *"Mais de 510.000"*, para a frase nunca prometer mais do
que os vídeos entregam.

**Caminho rápido:** some as views e as curtidas na mão e escreva em `viewsManual` e
`curtidasManual`, dentro de `dados/videos.json`. Leva alguns minutos e os dois números aparecem.

Enquanto os dois forem `0` e não houver chave de API, **os contadores não aparecem no site**.
Abrindo em `localhost` (com o `VER-LOCAL.bat`), aparece no lugar um aviso lembrando o que
preencher — esse aviso nunca é mostrado no site publicado.

**Caminho automático:** crie uma chave da YouTube Data API v3 e cole em `apiKeyYouTube`. A soma
de visualizações **e de curtidas** passa a ser feita ao vivo a cada visita, e os títulos dos
vídeos também vêm prontos. Observação: quando o dono de um vídeo esconde as curtidas, aquele
vídeo entra como zero — o total fica subestimado, nunca inflado.

1. Acesse `console.cloud.google.com` e crie um projeto.
2. Em *APIs e serviços → Biblioteca*, ative a **YouTube Data API v3**.
3. Em *Credenciais*, crie uma **chave de API**.
4. Clique na chave. Em *Restrições de aplicativo*, escolha **Referenciadores HTTP** e adicione
   `mathiascasalaspro.com.br/*` e `*.mathiascasalaspro.com.br/*`.
5. Em *Restrições de API*, marque só a YouTube Data API v3.

A chave fica visível no código-fonte, e isso é normal e seguro para esse uso, desde que você
faça a restrição do passo 4: ela só lê dados públicos e só funciona a partir do seu domínio.
A cota gratuita é de 10.000 unidades por dia; cada carregamento da página gasta 1.

**Enquanto não houver chave nem `viewsManual`, o bloco do número simplesmente não aparece.**
É de propósito: melhor não mostrar número nenhum do que mostrar um número inventado numa
página que um patrocinador vai conferir.

---

## 4. O que ainda falta preencher

- [ ] **Confirmar o ano de nascimento.** O campo `anoNascimento` em `dados/conteudo.json`
      está como **2012** e é o que calcula a idade em cada ano da linha do tempo
      (2026 · 14 anos, 2025 · 13 anos, e assim por diante). Se estiver errado, todas as
      idades saem erradas de uma vez.
- [ ] **Confirmar a norma de MI de Leça.** Ela aparece no hero, nos números, na história, nas
      conquistas e na seção do caminho. Se ainda não foi homologada, é a primeira coisa a ajustar.
- [ ] **Conferir os quatro selos de recorde:** três "Inédito no Brasil" (primeiro GM aos 9 em
      simultânea, GM em clássica aos 11, jogador 2550+ em clássica) e um "Estreia do Brasil"
      (Olimpíada Sub-16). Selo de recorde é o que alguém confere primeiro.
- [ ] **Foto do "Jogo dos Hábitos"** — é o único produto sem imagem. Salve em `assets/loja/`
      e escreva o nome do arquivo no campo `imagem`, em `dados/conteudo.json`. Enquanto não
      houver, o card mostra um peão dourado sobre o padrão de peças.
- [ ] **Conferir os links de apoio.** Os quatro valores (R$ 10, R$ 50, R$ 100 e Outro) apontam
      para planos do Mercado Pago herdados do site antigo. Confirme qual `plan_id` corresponde a
      qual valor.
- [ ] **Meta e valor arrecadado da temporada**, em `dados/conteudo.json`.
- [ ] **E-mail de contato**, em `dados/conteudo.json` (o WhatsApp já está ligado ao número
      (11) 99961-0210 em todos os botões).
- [ ] **PDF do mídia kit** em `assets/midia-kit-mathias.pdf` — o botão já aponta para lá.
- [ ] **Confirmar a habilitação na Lei de Incentivo ao Esporte.** Se o projeto não estiver
      habilitado, apague esse parágrafo: é a única frase da página que pode gerar problema jurídico.
- [ ] **Trocar `assets/og-mathias.jpg`** pela versão definitiva (prompt no
      `PROMPTS-DE-IMAGEM.md`). É a imagem que aparece quando alguém manda o link no WhatsApp.

---

## 5. Três decisões que valem explicar

**A idade não aparece em nenhum texto corrido.** Só as idades dos feitos ("aos 11 anos,
derrotou um GM"), que nunca desatualizam. Um site que diz "tenho 13 anos" está errado em
poucos meses, e informação desatualizada é o primeiro sinal de projeto abandonado.

**As conquistas são uma lista seca, e isso é de propósito.** Antes dela vem um quadro
explicando GM, FM, rating e norma — porque quem assina patrocínio geralmente não joga xadrez e
não sabe o que significa "2341". Traduzido o vocabulário uma vez, a lista pode ser direta.

**A seção "O caminho até o Mestre Internacional" é a mais importante da página.** Ninguém doa
para um objetivo abstrato; doa para um objetivo com regra clara, prazo e conta aberta. Se for
cortar algo por falta de tempo, corte outra coisa.

---

## 6. Detalhe técnico, para quem for mexer no código

O `index.html` já vem com o conteúdo escrito dentro dele — inclusive a lista de vídeos, num
bloco `<script type="application/json" id="videosReserva">`. Isso é a **rede de segurança**:
se algum JSON quebrar, ou se a página for aberta em `file://`, o site continua completo com a
versão do dia da publicação em vez de aparecer vazio. Quando os JSON carregam — o que leva
milésimos —, eles substituem esse conteúdo.

Consequência: se você editar os JSON e nunca mais tocar no HTML, o conteúdo dentro do HTML vai
ficando velho. Isso não afeta o que as pessoas veem, só o que um robô sem JavaScript leria. De
vez em quando vale copiar o conteúdo atual de volta para o HTML — ou simplesmente ignorar,
porque Google e Bing executam JavaScript há anos.

Os JSON são buscados com um sufixo que muda a cada cinco minutos (`?v=...`). É o que garante
que uma edição apareça rápido mesmo com a Cloudflare cacheando na frente.

---

## 7. Os três idiomas

O site é trilíngue: português, inglês e italiano. As bandeiras ficam no topo, ao lado do menu,
e os links `PT / EN / IT` do rodapé fazem a mesma coisa. Não existem três páginas — é a mesma
página trocando os textos.

**Qual idioma abre primeiro:** o `?lang=` da URL, se houver; senão o último escolhido pela
pessoa; senão o idioma do navegador dela; senão português. Cada troca grava `?lang=xx` no
endereço, então dá para mandar `mathiascasalaspro.com.br/?lang=it` direto para um contato
italiano.

### Onde ficam os textos

**Interface** (menus, títulos, botões, textos fixos): `dados/idiomas/pt.json`, `en.json` e
`it.json`. As três chaves são idênticas nos três arquivos. Corrigiu uma frase em português?
Edite `pt.json`. **Se uma chave faltar em `en.json` ou `it.json`, o site usa a versão em
português** — nada quebra, só não fica traduzido.

**Conteúdo** (conquistas, produtos, números): fica em `dados/conteudo.json`, com o campo
principal em português e sufixos `_en` e `_it` para as traduções:

```json
{
  "ano": "2026",
  "texto": "5º lugar no geral do Leça Chess Open...",
  "texto_en": "5th overall at the Leça Chess Open...",
  "texto_it": "5º posto assoluto al Leça Chess Open..."
}
```

Isso vale para `texto`, `local`, `selo`, `rotulo`, `descricao`, `nome` e `grupo`. **Adicionar
uma conquista nova só exige o português.** As traduções podem vir depois, sem quebrar nada:
enquanto não existirem, aquele item aparece em português nas três versões.

**Títulos de matérias na imprensa não são traduzidos** — são manchetes reais e devem ficar
como foram publicadas. Só o nome do grupo ("Olimpíada Mundial Sub-16") é traduzido.

### Antes de mexer

Os três arquivos de idioma aceitam HTML dentro dos textos: é assim que `<strong>` e `<em>`
funcionam no meio das frases. Se apagar uma tag de abertura sem apagar a de fechamento, aquele
trecho fica torto — mas o resto da página continua de pé.
