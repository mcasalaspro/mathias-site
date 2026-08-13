# Prompts de imagem — site do Mathias

> **Status em 13/08/2026.** As fotos da galeria agora ficam em `assets/galeria/` — basta
> largar novas lá que elas entram no site sozinhas (veja o `LEIA-ME.md`).
>
> **Status anterior, em 12/08/2026.** Os prompts das partes 1, 2.1, 2.2, 2.3, 3.3 e um divisor
> ornamental já foram executados e as imagens resultantes **já estão no site**, na pasta
> `assets/`. Continuam pendentes: monograma (3.1), Open Graph definitivo (3.2), capa do
> mídia kit (3.4), miniaturas de vídeo (3.5), ícones de plano (3.6) e selo de norma (3.7).
> **Leia o aviso da Parte 0 antes de gerar qualquer coisa nova.**

---

## PARTE 0 — Aviso sobre uma das imagens geradas

Entre os arquivos tratados veio uma versão de Pontevedra **recriada**, não corrigida:
salão barroco com lustres, plateia sentada e um adversário na frente do Mathias. A foto
original é um ginásio poliesportivo, com lona amarela no teto, e ele está sozinho na mesa.

A imagem é bonita e está salva em `assets/_NAO-USAR-pontevedra-recriada.jpg`, mas **não foi
colocada no site**, por um motivo prático: o site inteiro é construído sobre credibilidade
verificável — rating, normas, resultados no chess-results, certificado da FIDE. Um patrocinador
que descobrir que a foto do torneio foi inventada passa a duvidar do resto. É o único tipo de
erro nessa página que custa caro.

Se quiser aproveitá-la, use só onde fica claro que é ilustração e não registro: capa de vídeo,
arte de post com tratamento gráfico evidente, fundo de convite. Nunca com legenda de torneio,
data ou local.

Em vez dela, o site usa a versão fiel (`mathias-retrato.jpg`), que ficou muito boa: o cast
verde do ginásio saiu, a lona amarela recuou, a camisa e o banner do torneio estão legíveis.

Paleta do site, derivada da camisa oficial. Todo prompt daqui referencia estes hex:

| Uso | Hex |
|---|---|
| Fundo profundo | `#071523` |
| Azul da camisa | `#0E2A44` |
| Azul claro | `#143A5C` |
| Ouro | `#C9A24B` |
| Ouro claro | `#E6C77A` |
| Marfim (peça branca) | `#F1EBDF` |

---

## Regras que valem para TODOS os prompts

O Mathias é menor de idade. Isso muda o que se pode e não se pode pedir a uma IA:

1. **Nunca gere um rosto.** Use só ferramentas de *edição* sobre a foto real — Photoshop (Generative Fill / Neural Filters), Photoroom, Magnific, Topaz, Krea Enhance, ou modelos de img2img com força baixa (`denoise 0.15–0.30`). Text-to-image puro está fora de questão.
2. **Toda instrução precisa incluir a trava:** `Do not alter the subject's face, facial features, proportions, skin texture, age or identity in any way. Do not slim, reshape or beautify. Treat the face as a locked region.`
3. **Não invente conquistas visuais.** Nada de acrescentar medalhas, troféus, logos de patrocinador ou bandeiras que não estavam lá. O site vende credibilidade; uma foto adulterada destrói isso.
4. **Não coloque rostos de terceiros em destaque.** Nas fotos de torneio há adversários, pais e crianças identificáveis. Desfoque ou escureça — não os deixe nítidos em primeiro plano sem autorização.
5. **Exporte em WebP**, largura máxima 1600px, qualidade 78–82. O motivo do site atual estar lento é peso de imagem + Elementor. Não repita o primeiro erro ao corrigir o segundo.

---

# PARTE 1 — O prompt principal (foto do hero)

**Imagem de origem:** `mathias-hero.jpg` — retrato vertical, boné vermelho "Alfieri del Garda", mão no queixo, bandeiras desfocadas ao fundo, peças brancas em primeiro plano.

**O problema:** é a melhor foto de expressão do conjunto — concentração real, não posada. Mas o vermelho do boné e o verde/amarelo das bandeiras brigam com o azul-marinho e ouro da identidade. Num hero em tela cheia, o boné vira o assunto da página.

**A solução:** não remover o boné (seria falsificar), e sim reequilibrar a cena para que o vermelho vire um acento controlado dentro da paleta, e não o protagonista.

```
Professional color grade and retouch of this existing photograph of a young chess
player. This is a photo EDIT task, not image generation.

LOCKED REGIONS — do not modify: the subject's face, glasses, hands, hair,
proportions, skin texture and identity. No beautification, no reshaping, no age
change. Keep the red cap and its "Alfieri del Garda" logo present and legible —
it is a real team affiliation, not a design element to remove.

COLOR GRADE:
- Push the overall image toward a deep navy tonality. Shadows lifted slightly and
  tinted #071523. Midtones cooled toward #0E2A44.
- Desaturate the background flags by roughly 60% so the yellow, green and light
  blue read as soft neutral shapes, not competing color blocks.
- Bring the red of the cap down in saturation and luminance so it reads as a deep
  controlled crimson rather than a bright primary red. It should sit inside the
  palette, not fight it. Do not turn it grey and do not remove it.
- Warm highlights toward #E6C77A. Add a subtle warm gold rim light along the
  subject's left shoulder, jaw line and the top edge of the cap, as if from a
  tournament hall lamp. Keep it physically plausible — soft falloff, no glow ring.
- The ivory chess pieces in the foreground should read as warm #F1EBDF, clearly
  separated from the cool background.

DEPTH AND FOCUS:
- Deepen the background blur so the flags and the wall fall further back. The face
  and the hand stay tack sharp.
- Darken the top-left and bottom-right corners with a gentle vignette so the eye
  goes to the eyes and the hand.

FINISH:
- Fine film grain, very low. Contrast: medium-high, filmic curve, no crushed blacks.
- Deliver a version where the lower 25% of the frame fades cleanly to #071523,
  so the image can sit over a dark section without a visible edge.

OUTPUT: vertical 1200x2160px, sharp, no text, no added objects, no logos beyond
what is already in the frame. Also export a 2:3 crop at 1000x1500 for mobile.
```

**Como conferir se deu certo:** abra o resultado ao lado da camisa oficial. Se as duas imagens parecem do mesmo campeonato, funcionou. Se o boné continua sendo a primeira coisa que você vê, refaça baixando mais a saturação do vermelho.

---

# PARTE 2 — Prompts para as outras quatro fotos

## 2.1 `mathias-retrato.jpg` — Pontevedra (seção "A história")

Foto boa: camisa oficial visível, sorriso natural, tabuleiro montado. Problema: luz de ginásio (verde-amarelada mista), lona amarela enorme no teto, fundo ocupado.

```
Photo edit of an existing photograph. LOCKED: face, glasses, hands, hair,
proportions, identity, and the team jersey design including all visible sponsor
logos and the Brazilian flag patch — these must remain exactly as they are.

FIX THE LIGHTING:
- Neutralize the mixed green/yellow gymnasium cast. Set a clean white balance
  using the white chess pieces as the neutral reference.
- Recover the highlights on the face and shirt; the jersey navy should read as a
  rich #0E2A44 with its gold trim clearly visible.

CALM THE BACKGROUND:
- Reduce the luminance of the large yellow ceiling tarp by about 50% and
  desaturate it so it becomes a warm neutral band instead of a bright yellow mass.
- Increase background blur one stop. Any other people in the frame should be
  soft enough not to be individually identifiable.
- Keep the Spanish and regional flags and the tournament banner readable — they
  prove where the photo was taken.

FINISH:
- Warm the wooden board and pieces slightly toward #F1EBDF and a honeyed brown.
- Gentle vignette. Natural skin tones — do not tan, whiten or smooth.

OUTPUT: 3:4 crop, 1200x1600px, subject's eyes on the upper third line.
```

## 2.2 `mathias-leca.jpg` — Portugal, medalha + troféu + certificado

É a foto mais importante do site inteiro: prova documental da norma. Também é a de pior qualidade técnica — celular, ginásio, fundo com pessoas, papel estourado.

```
Photo restoration and edit of an existing smartphone photograph.

LOCKED: the subject's face, hands, posture, identity; the medal; the trophy and
all text printed on it; the certificate and every character printed on it. These
are documentary evidence and must not be altered, re-rendered or "cleaned up"
into different text.

RESTORE:
- Denoise and sharpen. Recover blown highlights on the white certificate so the
  printed text becomes legible instead of a white rectangle.
- Correct the industrial lighting cast to neutral.
- Increase local contrast on the trophy so "LEÇA CHESS OPEN / 1st PLACE / Under 14"
  reads clearly at small sizes.
- Keep the row of national flags in the background sharp enough to be recognizable
  — they carry the "international tournament" meaning.

BACKGROUND:
- Darken and blur the people in the mid and far background until they are not
  individually identifiable. Do not remove them — the crowd shows it was a real
  event.
- Deepen the floor and ceiling toward #071523 so the subject separates.

GRADE: same navy-and-gold palette as the rest of the set. Warm rim light on the
left side of the subject.

OUTPUT: two crops — a 3:4 portrait at 1200x1600 and a 4:5 detail crop at 1080x1350
framed on the hands, the certificate and the trophy.
```

> Vale a pena também fotografar o certificado e o troféu separados, em cima de uma mesa escura, com luz difusa. Vira um cartão de "prova" muito mais forte que a foto de corpo inteiro.

## 2.3 `assets/galeria/2026-02_floripa-blitz-abertura.jpg` — faixa larga do site

Já é a melhor foto do conjunto em composição. Precisa de pouco.

```
Photo edit of an existing photograph. LOCKED: the two players' faces, hands and
identities; the board position; the clock reading; the board number sign.

- Grade toward the navy-and-gold palette: cool the crowd and the hall, keep the
  wooden board and ivory pieces warm so the board is the brightest object.
- Reduce the chandelier's blown highlights.
- Add a soft gradient darkening the top 20% and the bottom 25% of the frame toward
  #071523, so overlaid caption text stays readable without a solid bar.
- Blur and darken the spectators enough that no face in the background is
  individually identifiable, while the crowd density remains obvious — the crowd
  IS the story here.
- Keep the two players sharp.

OUTPUT: 16:9 at 1920x1080 and a 21:9 crop at 2000x860 for the full-width band.
```

## 2.4 `camisa-oficial.jpg` — mockup da camisa (seção de patrocínio)

Hoje é um mockup chapado sobre fundo branco. Numa seção escura, ele abre um buraco branco na página.

```
Product photography edit of an existing apparel mockup showing the front and back
of a navy chess team polo shirt.

LOCKED: the garment design, the gold collar trim, the diamond pattern, all
existing logos, the "MATHIAS CASALASPRO" lettering and the word "XADREZ".

- Replace the flat white background with a dark studio backdrop in #071523,
  with a subtle radial falloff so the shirts sit in a pool of light.
- Add realistic studio product lighting: a large soft key from the upper left, a
  warm #C9A24B rim light along the right edge of both garments, and a soft
  contact shadow under each shirt.
- Give the fabric believable texture and micro-wrinkles; it currently looks like
  flat vector art.
- Keep the two shirts in the same relative position and scale.

OUTPUT: 3:2 at 1800x1200, transparent-PNG version as well.
```

---

# PARTE 3 — Assets para criar do zero

Estes não partem de foto, então pode usar geração normal.

## 3.1 Monograma / selo da marca

Hoje o site não tem marca própria — só o nome. Um selo resolve favicon, avatar de rede social, marca d'água em foto e carimbo no mídia kit de uma vez.

```
Flat vector monogram for a chess athlete's personal brand. A square badge with
slightly rounded corners. Inside: the letters "MC" interlocked, drawn in a heavy
grotesque sans-serif, cut so the negative space between them forms the silhouette
of a knight's head. Two opposite corners of the square are filled, like a
chessboard's light and dark squares.

Colors: #0E2A44 background, #C9A24B letterforms, thin #C9A24B border.
Style: geometric, sharp, no gradients, no bevels, no 3D, no shadows.
Must stay legible at 32x32 pixels.

Deliver: SVG, on transparent background, plus a one-color version in #F1EBDF
and a one-color version in #071523.
```

## 3.2 Imagem de compartilhamento (Open Graph, 1200×630)

É a imagem que aparece quando alguém manda o link no WhatsApp. Hoje o site usa uma miniatura genérica do Elementor.

```
Social share card, 1200x630px, landscape. Left two thirds: solid #071523 with a
faint 8x8 chessboard grid drawn in 1px #C9A24B lines at 8% opacity. Right third:
space reserved for a cut-out portrait photograph, with the background fading from
transparent into #071523 at the seam.

Text block on the left, left-aligned, generous margins:
- "MATHIAS CASALASPRO" in heavy condensed sans, #F1EBDF, two lines.
- Below it, a thin #C9A24B rule.
- Below the rule, in monospace small caps, #8FA6BD: "MESTRE FIDE · A CAMINHO DO
  TÍTULO DE MESTRE INTERNACIONAL".
A 6px #C9A24B bar runs along the very top edge of the card.

No stock photos, no shine, no drop shadows.
```

## 3.3 Textura de fundo (padrão da camisa)

A camisa tem um padrão tom-sobre-tom de peões/losangos. Repetir isso no site amarra o digital ao físico.

```
Seamless tileable pattern, 400x400px. A subtle diamond lattice with a small
stylized chess pawn silhouette centered inside each diamond. Tone-on-tone: shapes
in #143A5C on a #0E2A44 background, contrast so low the pattern is almost
subliminal. Flat, no lighting, no texture noise. Must tile perfectly on all
four edges.

Deliver a second version in #F1EBDF shapes on #FBF8F3 for light sections.
```

## 3.4 Capa do mídia kit (PDF de patrocínio)

O site tem um botão "Baixar o mídia kit". Falta o kit.

```
Cover page for a sports sponsorship media kit, A4 portrait, 300dpi.
Background #071523. A large 8x8 chessboard grid in 1px #C9A24B lines at 6%
opacity, bleeding off the bottom edge. A single gold pawn silhouette in the lower
right, oversized and cropped by the page edge.

Type, left-aligned, top third:
- Eyebrow in monospace: "MÍDIA KIT · 2027"
- Headline in heavy sans, #F1EBDF: "MATHIAS CASALASPRO"
- Subhead in #C9A24B: "Mestre FIDE · Xadrez · Brasil"

Bottom left: space for a contact line. Nothing else. Editorial, restrained,
no gradients, no stock imagery.
```

## 3.5 Miniaturas dos vídeos

O site carrega a capa do YouTube. Se quiser capas próprias e consistentes:

```
YouTube thumbnail template, 1280x720. Background #071523. Left 55%: space for a
cropped photo of the player, faded into the background on its right edge. Right
45%: a stack of text on a clean field —
- a small #C9A24B monospace eyebrow line for the tournament name,
- a two-line heavy sans headline in #F1EBDF for the game description,
- a thin gold rule between them.
Bottom left corner: a small square monogram badge.
Flat design, no arrows, no shocked faces, no red circles. Should look like a
broadcast graphic, not a reaction video.
```

## 3.6 Ícones dos planos de patrocínio

```
Set of three flat line icons on transparent background, 96x96px each, 2px stroke
in #C9A24B, geometric and consistent:
1. A pawn inside a square outline — "Apoiador".
2. A knight inside a square outline — "Patrocinador".
3. A queen inside a square outline with a small filled corner — "Patrocinador Oficial".
Same optical weight, same silhouette language, no fills, no gradients, no shadows.
```

## 3.7 Selo "Norma de MI conquistada"

Um carimbo que pode ir em post, foto e no site quando cada norma cair.

```
Circular badge, 400x400px, transparent background. Outer ring in #C9A24B with the
text "NORMA DE MESTRE INTERNACIONAL" running around the top arc in monospace small
caps, and "LEÇA · PORTUGAL · 2026" around the bottom arc. Center: a single filled
pawn silhouette in #C9A24B. Thin double ring border. Flat vector, looks like an
engraved federation seal, no gradients, no metallic effect.

Deliver a second empty version with the arcs blank, to reuse for future norms.
```

---

# PARTE 4 — Ordem de execução sugerida

1. **Monograma** primeiro. Ele define o favicon, o selo do menu e o carimbo de todas as outras peças.
2. **Foto do hero.** É a única imagem que a pessoa vê antes de decidir se fica.
3. **Foto de Portugal.** É a prova. Sem ela, o texto sobre a norma é só uma afirmação.
4. **Imagem de compartilhamento.** Todo link compartilhado até hoje entregou uma miniatura genérica; isso é tráfego perdido.
5. As demais, conforme a agenda.
