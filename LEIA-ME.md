# Site do Mathias — publicar e manter

HTML puro, sem WordPress, sem Elementor, sem framework, sem build. Feito para viver num
repositório do GitHub e ser servido pela Cloudflare.

**A regra mais importante: você não precisa abrir o `index.html` para atualizar o site.**
Tudo que muda está em `dados/`, em três arquivos de texto simples.

```
PUBLICAR.bat                  envia tudo para o GitHub (Windows)
VER-LOCAL.bat                 abre o site na sua máquina para conferir
index.html                    o site (não precisa ser editado)
dados/conteudo.json           números, conquistas, imprensa, contato
dados/videos.json             lista de vídeos do YouTube
dados/galeria.json            legendas das fotos (gerado sozinho)
assets/                       imagens fixas
assets/galeria/               é só jogar fotos aqui
.github/workflows/galeria.yml a rotina que indexa a pasta de fotos
_headers                      regras de cache da Cloudflare
```

---

## 1. Publicar (Windows, com o PUBLICAR.bat)

### Antes de tudo: instalar o Git, uma vez só

Baixe em <https://git-scm.com/download/win> e instale aceitando todas as opções padrão.
São uns três minutos. É o programa que leva os arquivos daqui até o GitHub.

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

Depois disso, o Windows abre uma janela pedindo para entrar na sua conta do GitHub. Faça o
login e pronto: os arquivos sobem. Da segunda vez em diante, o login não é mais pedido.

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

### Fotos → é só jogar na pasta

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

**Caminho rápido:** some as views na mão e escreva em `viewsManual`, dentro de
`dados/videos.json`. Leva dois minutos e o número aparece.

**Caminho automático:** crie uma chave da YouTube Data API v3 e cole em `apiKeyYouTube`. A
soma passa a ser feita ao vivo a cada visita, e os títulos dos vídeos também vêm prontos.

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

- [ ] **Confirmar a norma de MI de Leça.** Ela aparece no hero, nos números, na história, nas
      conquistas e na seção do caminho. Se ainda não foi homologada, é a primeira coisa a ajustar.
- [ ] **Conferir os quatro selos de recorde:** três "Inédito no Brasil" (primeiro GM aos 9 em
      simultânea, GM em clássica aos 11, jogador 2550+ em clássica) e um "Estreia do Brasil"
      (Olimpíada Sub-16). Selo de recorde é o que alguém confere primeiro.
- [ ] **Valores dos três planos de patrocínio** — estão como `R$ ___` no `index.html`, na seção
      de patrocínio. São os únicos textos que ainda pedem edição no HTML.
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

## 7. Versões em outros idiomas

O rodapé já tem `PT / EN / IT` apontando para `/mathias-chess` e `/mathias-scacchi`, como no
site atual. Para traduzir, duplique `index.html` e os arquivos de `dados/`, traduza os textos e
troque o `lang` do `<html>`.
