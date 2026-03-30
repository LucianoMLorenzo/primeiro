# Gera PPT: IA e a Industria de Software
# Encoding: ASCII-safe para PowerShell

$outputPath = "D:\VScode\projetoSOFTAWAREIA\IA_Impacto_Software.pptx"

$corFundo      = 0x3A1C1C   # BGR: azul escuro
$corAcento     = 0x6045E9   # BGR: vermelho/rosa
$corAcento2    = 0xB0C94E   # BGR: verde-azulado
$corBranco     = 0xFFFFFF
$corCinza      = 0xCCCCCC
$corAmarelo    = 0x18C5F5
$corFundoCard  = 0x301414

function BGR($r, $g, $b) { return ($b -shl 16) -bor ($g -shl 8) -bor $r }

$cFundo     = BGR 0x1C 0x1C 0x3A
$cAcento    = BGR 0xE9 0x45 0x60
$cVerde     = BGR 0x4E 0xC9 0xB0
$cBranco    = BGR 0xFF 0xFF 0xFF
$cCinza     = BGR 0xCC 0xCC 0xCC
$cAmarelo   = BGR 0xF5 0xC5 0x18
$cCard      = BGR 0x14 0x14 0x30
$cEscuro    = BGR 0x0D 0x0D 0x1A
$cCinzaEsc  = BGR 0x88 0x88 0x88

$ppt = New-Object -ComObject PowerPoint.Application
$ppt.Visible = [Microsoft.Office.Core.MsoTriState]::msoTrue
$pres = $ppt.Presentations.Add()
$pres.PageSetup.SlideWidth  = 960
$pres.PageSetup.SlideHeight = 540
$slides = $pres.Slides

function SetBg($slide, $color) {
    $slide.Background.Fill.ForeColor.RGB = $color
    $slide.Background.Fill.Solid()
}

function TBox($slide, $txt, $l, $t, $w, $h, $sz, $clr, $bold, $align) {
    $tb = $slide.Shapes.AddTextbox(1, $l, $t, $w, $h)
    $tb.TextFrame.WordWrap = -1
    $tf = $tb.TextFrame.TextRange
    $tf.Text = $txt
    $tf.Font.Name  = "Segoe UI"
    $tf.Font.Size  = $sz
    $tf.Font.Bold  = if ($bold) { -1 } else { 0 }
    $tf.Font.Color.RGB = $clr
    $tf.ParagraphFormat.Alignment = $align
    $tb.TextFrame.AutoSize = 0
    return $tb
}

function Linha($slide, $l, $t, $w, $clr, $wt) {
    $ln = $slide.Shapes.AddLine($l, $t, ($l+$w), $t)
    $ln.Line.ForeColor.RGB = $clr
    $ln.Line.Weight = $wt
}

function Rect($slide, $l, $t, $w, $h, $clr) {
    $r = $slide.Shapes.AddShape(1, $l, $t, $w, $h)
    $r.Fill.ForeColor.RGB = $clr
    $r.Fill.Solid()
    $r.Line.Visible = $false
    return $r
}

function Header($slide, $bloco, $titulo) {
    SetBg $slide $cFundo
    Rect  $slide 0 0 10 540 $cAcento | Out-Null
    TBox  $slide $bloco  20 15 900 28 11 $cAcento  $true  1 | Out-Null
    Linha $slide 20 46 920 $cAcento 1
    TBox  $slide $titulo 20 55 920 58 30 $cBranco  $true  1 | Out-Null
}

# ===== SLIDE 1 - TITULO =====
$s = $slides.Add(1, 12)
SetBg $s $cFundo
Rect  $s 0 0 10 540 $cAcento | Out-Null
Rect  $s 0 455 960 85 $cEscuro | Out-Null
TBox  $s "IA E A INDUSTRIA DE SOFTWARE" 40 100 880 75 36 $cBranco $true 1 | Out-Null
TBox  $s "Disrupcao, Oportunidade e os Novos Modelos de Valor" 40 185 880 45 22 $cVerde $false 1 | Out-Null
Linha $s 40 240 880 $cAcento 2
TBox  $s "Apresentacao Executiva  |  60 minutos  |  Keynote para Painel de Debate" 40 250 880 32 13 $cCinza $false 1 | Out-Null
TBox  $s "Publico: Executivos e Investidores da Industria de Software" 40 282 880 28 12 $cCinza $false 1 | Out-Null
TBox  $s "Versao 1.0" 40 470 880 25 11 $cCinzaEsc $false 1 | Out-Null

# ===== SLIDE 2 - AGENDA =====
$s = $slides.Add(2, 12)
SetBg $s $cFundo
Rect  $s 0 0 10 540 $cAcento | Out-Null
TBox  $s "ESTRUTURA DA APRESENTACAO" 20 20 920 38 24 $cBranco $true 1 | Out-Null
Linha $s 20 62 920 $cAcento 1

$blocos = @(
    @("01", "Abertura: O Chao Esta Se Movendo",          "5 min",  $cAcento),
    @("02", "O Que a IA Ja Mudou - Dados e Evidencias",  "15 min", $cVerde),
    @("03", "Onde o Modelo de Negocio E Desafiado",      "15 min", $cAmarelo),
    @("04", "Cenarios para os Proximos 3-5 Anos",        "10 min", (BGR 0x74 0xB9 0xFF)),
    @("05", "Questoes Abertas para o Debate",            "10 min", (BGR 0xFD 0x79 0xA8)),
    @("06", "Encerramento: A Pergunta que Importa",      "5 min",  $cAcento)
)
$y = 76
foreach ($b in $blocos) {
    Rect  $s 20 $y 50 36 $b[3] | Out-Null
    TBox  $s $b[0] 20 ($y+6) 50 24 14 $cFundo $true 2 | Out-Null
    TBox  $s $b[1] 80 ($y+8) 760 24 13 $cBranco $false 1 | Out-Null
    TBox  $s $b[2] 850 ($y+8) 90 24 13 $b[3] $true 3 | Out-Null
    $y += 46
}

# ===== SLIDE 3 - BLOCO 1 PROVOCACAO =====
$s = $slides.Add(3, 12)
Header $s "BLOCO 1  |  ABERTURA (5 min)" "O Chao Esta Se Movendo"
Rect   $s 40 125 880 165 (BGR 0x2A 0x0A 0x15) | Out-Null
TBox   $s '"A maior ameaca para uma empresa de software nao e a IA.' 60 133 840 35 18 $cAcento $false 2 | Out-Null
TBox   $s 'E continuar acreditando que seu produto e software."' 60 168 840 35 18 $cAcento $false 2 | Out-Null
Linha  $s 200 210 560 $cAcento 1
TBox   $s "Intencao: Desestabilizar a zona de conforto desde o inicio." 60 218 840 28 11 $cCinza $false 2 | Out-Null

TBox   $s "FATOS DE ABERTURA" 40 305 880 22 12 $cVerde $true 1 | Out-Null
TBox   $s ">  Em 18 meses (jan/2023 a jun/2024): GitHub Copilot atingiu 1,8 milhao de devs pagantes - a curva de adocao mais rapida da historia da industria." 40 328 880 33 12 $cBranco $false 1 | Out-Null
TBox   $s ">  McKinsey: 30% das tarefas de desenvolvimento ja podem ser automatizadas com ferramentas de IA disponiveis hoje." 40 362 880 33 12 $cBranco $false 1 | Out-Null

# ===== SLIDE 4 - PERGUNTA DE ABERTURA =====
$s = $slides.Add(4, 12)
SetBg  $s $cEscuro
Rect   $s 0 0 960 5 $cAcento | Out-Null
Rect   $s 0 535 960 5 $cAcento | Out-Null
TBox   $s "PERGUNTA PARA O PUBLICO" 0 40 960 28 13 $cAcento $true 2 | Out-Null
TBox   $s "Quantos de voces ja mudaram algum processo, produto ou decisao de investimento por causa da IA generativa?" 80 100 800 80 22 $cBranco $false 2 | Out-Null
TBox   $s "Quantos sentem que ainda estao avaliando?" 80 200 800 45 22 $cCinza $false 2 | Out-Null
Linha  $s 280 275 400 $cAcento 2
TBox   $s "(slide de votacao rapida - sem texto adicional)" 0 300 960 28 12 $cCinzaEsc $false 2 | Out-Null

# ===== SLIDE 5 - VELOCIDADE DA RUPCAO =====
$s = $slides.Add(5, 12)
Header $s "BLOCO 2  |  DADOS E EVIDENCIAS (15 min)" "A Velocidade da Rupcao Nao Tem Precedente Historico"
TBox   $s "Tempo ate atingir 100 milhoes de usuarios:" 20 122 920 22 12 $cVerde $true 1 | Out-Null

$techs = @("Internet", "Smartphones", "ChatGPT")
$anos  = @("~7 anos", "~5 anos", "2 meses")
$tcor  = @((BGR 0x2D 0x35 0x61), (BGR 0x2D 0x35 0x61), (BGR 0x5C 0x0A 0x15))
$x = 40
for ($i = 0; $i -lt 3; $i++) {
    Rect $s $x 148 260 95 $tcor[$i] | Out-Null
    TBox $s $techs[$i] $x 156 260 24 14 $cCinza $false 2 | Out-Null
    $ac = if ($i -eq 2) { $cAcento } else { $cBranco }
    TBox $s $anos[$i] $x 182 260 36 26 $ac $true 2 | Out-Null
    TBox $s "ate 100M usuarios" $x 218 260 20 10 $cCinzaEsc $false 2 | Out-Null
    $x += 300
}

TBox   $s "Implicacao estrategica:" 20 262 920 22 12 $cVerde $true 1 | Out-Null
TBox   $s "A janela de adaptacao esta mais curta do que qualquer disrupcao anterior que a industria de software viveu - incluindo mobile e cloud." 20 284 920 40 13 $cBranco $false 1 | Out-Null

Rect   $s 20 345 920 80 $cCard | Out-Null
TBox   $s "Nota: Nas transicoes mobile e cloud havia anos para aprender e pivotar. A IA generativa compressa essa janela de forma sem precedente historico." 35 358 890 55 12 $cCinza $false 1 | Out-Null

# ===== SLIDE 6 - PRODUTIVIDADE DEV =====
$s = $slides.Add(6, 12)
Header $s "BLOCO 2  |  DADOS E EVIDENCIAS" "Produtividade do Desenvolvedor: Impacto Mensuravel"

$dados = @(
    @("55%", "mais rapido", "GitHub/Microsoft 2023", "Devs com Copilot completaram tarefas de codificacao 55% mais rapido em testes controlados"),
    @("25%+", "do codigo novo", "Google 2024", "Internamente, IA gera mais de 25% do codigo novo em alguns produtos da empresa"),
    @("20-45%", "menos tempo", "McKinsey 2024", "Reducao no tempo de ciclo de entrega de features em empresas com IA generativa")
)
$x = 20
foreach ($d in $dados) {
    Rect $s $x 118 300 260 $cCard | Out-Null
    TBox $s $d[0] $x 128 300 65 42 $cAcento $true 2 | Out-Null
    TBox $s $d[1] $x 196 300 28 13 $cVerde $false 2 | Out-Null
    TBox $s $d[2] $x 226 300 22 10 $cAmarelo $true 2 | Out-Null
    TBox $s $d[3] ($x+8) 252 284 110 11 $cCinza $false 1 | Out-Null
    $x += 320
}

TBox   $s "Tensao: Se o dev e 55% mais produtivo, a empresa precisa de 55% menos devs - ou entrega 55% mais valor? Qual esta se concretizando?" 20 395 920 48 12 $cAcento $false 1 | Out-Null

# ===== SLIDE 7 - HEADCOUNT =====
$s = $slides.Add(7, 12)
Header $s "BLOCO 2  |  DADOS E EVIDENCIAS" "O Impacto nos Headcounts Ja E Visivel (2023-2025)"

$items = @(
    "Duolingo, Klarna, IBM e Salesforce anunciaram reducoes de headcount vinculadas a automacao por IA - especialmente suporte, QA e features padronizadas.",
    "Klarna (2024): CEO afirmou que a empresa opera com 700 funcionarios a menos do que precisaria sem IA - economia estimada de ~US$ 40M/ano.",
    "MIT Sloan (2024): 37% das empresas de software planejam NAO repor posicoes de desenvolvimento encerradas, confiando em ganhos via IA."
)
$y = 130
foreach ($item in $items) {
    Rect $s 20 $y 6 42 $cAcento | Out-Null
    TBox $s $item 34 ($y+4) 900 36 13 $cBranco $false 1 | Out-Null
    $y += 62
}

Rect   $s 20 328 920 65 (BGR 0x1A 0x2A 0x1A) | Out-Null
TBox   $s "Contexto: Esses dados convivem com escassez de talentos senior e crescimento de demanda por IA engineers. O mercado nao esta simplesmente encolhendo - esta se reshaping." 35 338 890 50 12 $cVerde $false 1 | Out-Null

# ===== SLIDE 8 - INVESTIMENTO =====
$s = $slides.Add(8, 12)
Header $s "BLOCO 2  |  DADOS E EVIDENCIAS" "O Investimento em IA na Industria de Software"

$metricas = @(
    @("US$ 91,9B -> 200B+", "Investimento global em IA empresarial (2023 -> 2026 projecao)", "IDC"),
    @("18% do R&D", "Destinado a iniciativas de IA pelas top 10 empresas de software em 2024", "Media big caps"),
    @("4,2x maior", "Valuation de startups AI-native vs. peers sem IA - com receitas comparaveis", "PitchBook 2024")
)
$y = 125
foreach ($m in $metricas) {
    Rect $s 20 $y 920 72 $cCard | Out-Null
    TBox $s $m[0] 30 ($y+10) 330 50 20 $cAcento $true 1 | Out-Null
    TBox $s $m[1] 370 ($y+18) 490 35 13 $cBranco $false 1 | Out-Null
    TBox $s $m[2] 875 ($y+26) 55 25 $cCinzaEsc $true 3 | Out-Null
    $y += 86
}

TBox   $s "Estamos pagando multiplos por expectativa futura - ou por algo que ja gera vantagem competitiva real hoje?" 20 410 920 38 13 $cAcento $false 1 | Out-Null

# ===== SLIDE 9 - DEMANDA CLIENTES =====
$s = $slides.Add(9, 12)
Header $s "BLOCO 2  |  DADOS E EVIDENCIAS" "O Lado da Demanda: O Que os Clientes Querem Agora"

Rect   $s 40 118 400 210 $cCard | Out-Null
TBox   $s "87%" 40 128 400 80 72 $cAcento $true 2 | Out-Null
TBox   $s "dos CIOs afirmam que IA e a prioridade #1 de investimento em tecnologia" 55 214 370 65 14 $cBranco $false 2 | Out-Null
TBox   $s "Gartner, 2024" 55 286 370 24 11 $cCinzaEsc $false 2 | Out-Null

Rect   $s 480 118 440 210 $cCard | Out-Null
TBox   $s "62%" 480 128 440 80 72 $cVerde $true 2 | Out-Null
TBox   $s "dos compradores enterprise dizem que IA e agora criterio de compra - nao diferencial, mas REQUISITO MINIMO" 495 214 410 80 14 $cBranco $false 2 | Out-Null
TBox   $s "Gartner, 2024" 495 300 410 24 11 $cCinzaEsc $false 2 | Out-Null

Rect   $s 20 348 920 58 (BGR 0x1C 0x1C 0x10) | Out-Null
TBox   $s "Produto sem IA esta virando commodity - ou pior, legacy." 35 360 890 38 18 $cAmarelo $true 1 | Out-Null

# ===== SLIDE 10 - MODELO SaaS =====
$s = $slides.Add(10, 12)
Header $s "BLOCO 3  |  MODELO DE NEGOCIO (15 min)" "O Modelo SaaS Como Conhecemos Esta Sendo Questionado"

TBox   $s "MODELO TRADICIONAL" 20 122 420 22 11 $cCinza $true 1 | Out-Null
$trad = @("Assinatura recorrente por seat/usuario","Valor = funcionalidades + UX + integracoes","Crescimento = mais usuarios + upsell de modulos")
$y = 148
foreach ($t in $trad) {
    TBox $s "o  $t" 20 $y 430 28 12 (BGR 0xAA 0xAA 0xAA) $false 1 | Out-Null
    $y += 30
}

Linha  $s 460 118 2 (BGR 0x33 0x33 0x55) 1
TBox   $s "DESAFIOS DA IA" 480 122 460 22 11 $cAcento $true 1 | Out-Null

$desafios = @(
    @("1", "Agentes substituem usuarios", "Se um agente executa tarefas de 10 usuarios, o modelo por seat entra em colapso"),
    @("2", "Outcome-based pricing emerge", "Klarna, Salesforce e ServiceNow ja cobram por resultado - por transacao, por caso resolvido"),
    @("3", "UX pode ser comoditizada", "Se o front-end vira interface conversacional, valor migra para dados e logica de negocio")
)
$y = 146
foreach ($d in $desafios) {
    Rect $s 480 $y 22 22 $cAcento | Out-Null
    TBox $s $d[0] 480 ($y+2) 22 18 $cFundo $true 2 | Out-Null
    TBox $s $d[1] 510 $y 430 20 12 $cBranco $true 1 | Out-Null
    TBox $s $d[2] 510 ($y+20) 430 26 11 $cCinza $false 1 | Out-Null
    $y += 56
}

TBox   $s "Quando o cliente paga pelo uso da IA em vez do acesso ao software, quem fica com o maior valor - o modelo de fundacao, a cloud ou a aplicacao?" 20 418 920 46 12 $cAcento $false 1 | Out-Null

# ===== SLIDE 11 - PLATAFORMIZACAO =====
$s = $slides.Add(11, 12)
Header $s "BLOCO 3  |  MODELO DE NEGOCIO" "A Ameaca dos Modelos de Fundacao Como Plataformas"

TBox   $s "OpenAI, Anthropic, Google e Meta estao construindo capacidades que antes eram o diferencial de ISVs especializados:" 20 118 920 32 13 $cBranco $false 1 | Out-Null
TBox   $s "geracao de codigo  |  analise de documentos  |  suporte ao cliente  |  analise de dados" 20 150 920 25 12 $cVerde $false 1 | Out-Null

Rect   $s 20 185 920 100 (BGR 0x1A 0x0A 0x05) | Out-Null
TBox   $s "Analogia historica:" 35 193 880 22 12 $cAmarelo $true 1 | Out-Null
TBox   $s "Quando o Excel incorporou tabelas dinamicas, acabou com dezenas de startups de BI. Quando o iOS incorporou mapas, destruiu valor de terceiros. A IA nos modelos de fundacao pode fazer o mesmo em escala muito maior." 35 215 880 62 12 $cBranco $false 1 | Out-Null

Rect   $s 20 302 920 80 $cCard | Out-Null
TBox   $s "3.000.000+" 20 308 460 45 36 $cAcento $true 2 | Out-Null
TBox   $s "GPTs customizados criados na plataforma OpenAI - essencialmente um ecossistema de micro-SaaS sem codigo, aberto a qualquer usuario ou empresa." 480 318 455 55 12 $cBranco $false 1 | Out-Null

TBox   $s "Onde termina a plataforma e onde comeca a aplicacao? O mercado ainda nao respondeu." 20 402 920 38 13 $cAcento $false 1 | Out-Null

# ===== SLIDE 12 - VERTICAL =====
$s = $slides.Add(12, 12)
Header $s "BLOCO 3  |  MODELO DE NEGOCIO" "Software Vertical: Ameacado ou Fortalecido?"

Rect   $s 20 118 455 30 (BGR 0x5C 0x0A 0x0A) | Out-Null
TBox   $s "TESE DA AMEACA" 20 122 455 24 12 $cBranco $true 2 | Out-Null
Rect   $s 485 118 455 30 (BGR 0x0A 0x3A 0x1A) | Out-Null
TBox   $s "TESE DO FORTALECIMENTO" 485 122 455 24 12 $cBranco $true 2 | Out-Null

$ameacas = @("LLMs genericos ja superam software especializado em muitas tarefas","Custo de criacao de concorrentes IA despenca drasticamente","Clientes consolidam em plataformas, compram menos produtos pontuais")
$forcas  = @("Dados proprietarios e contexto de dominio sao barreiras reais","Regulacao, compliance e confianca favorecem players estabelecidos","Integracao profunda com workflows cria lock-in legitimo")
$y = 152
for ($i = 0; $i -lt 3; $i++) {
    TBox $s "x  $($ameacas[$i])" 25 $y 445 44 12 $cCinza $false 1 | Out-Null
    TBox $s "v  $($forcas[$i])"  490 $y 445 44 12 $cCinza $false 1 | Out-Null
    $y += 50
}

TBox   $s "Harvey AI (juridico): valuation US$ 1,5B em 2024  |  Veeva Systems: aposta no moat regulatorio  |  Notion AI vs Microsoft Copilot: quem vence quando ambos tem IA?" 20 415 920 38 11 $cVerde $false 1 | Out-Null

# ===== SLIDE 13 - CANIBALIZACAO =====
$s = $slides.Add(13, 12)
Header $s "BLOCO 3  |  MODELO DE NEGOCIO" "O Risco de Canibalizacao Interna"

Rect   $s 20 118 920 88 (BGR 0x1A 0x1A 0x05) | Out-Null
TBox   $s "O Paradoxo da Adocao de IA para ISVs" 35 126 880 22 13 $cAmarelo $true 1 | Out-Null
TBox   $s "Incorporar IA no produto pode REDUZIR o volume de uso cobrado: o usuario precisa de menos interacoes para atingir o mesmo resultado - gerando menos receita, mesmo com mais satisfacao." 35 150 880 50 13 $cBranco $false 1 | Out-Null

$casos = @(
    "Atendimento com IA resolve tickets 3x mais rapido - se pricing e por ticket ou hora, a receita cai mesmo com o cliente mais satisfeito.",
    "Empresas de RH-tech reportam reducao de 30-40% no volume de transacoes manuais apos IA - sem reducao equivalente no preco pago.",
    "Plataformas de e-discovery juridico: IA reduziu horas faturadas de revisao em 60% - redistribuindo valor da plataforma para o cliente."
)
$y = 222
foreach ($c in $casos) {
    Rect $s 20 $y 6 36 $cAmarelo | Out-Null
    TBox $s $c 34 ($y+4) 900 30 12 $cBranco $false 1 | Out-Null
    $y += 48
}

TBox   $s "Como precificar inteligencia que, ao ser bem-sucedida, faz o cliente precisar menos de voce?" 20 402 920 38 14 $cAcento $false 1 | Out-Null

# ===== SLIDE 14 - INFRAESTRUTURA =====
$s = $slides.Add(14, 12)
Header $s "BLOCO 3  |  MODELO DE NEGOCIO" "Custos de Infraestrutura: A Equacao Que Ainda Nao Fechou"

$metrCards = @(
    @(20,  "100-1000x", "custo por query de LLM vs. request de API convencional", 280),
    @(320, "15-40%",   "aumento de custos de infra sem repasse proporcional ao cliente", 280),
    @(620, "Custo > Receita", "Microsoft: custo de infra do Copilot M365 era maior que a receita nos primeiros meses. Equacao so fecha com escala muito alta.", 320)
)
foreach ($mc in $metrCards) {
    Rect $s $mc[0] 118 $mc[3] 210 $cCard | Out-Null
    TBox $s $mc[1] $mc[0] 128 $mc[3] 58 26 $cAcento $true 2 | Out-Null
    TBox $s $mc[2] ($mc[0]+8) 192 ($mc[3]-16) 120 11 $cCinza $false 2 | Out-Null
}

Rect   $s 20 348 920 55 (BGR 0x1A 0x05 0x05) | Out-Null
TBox   $s "A corrida por IA gratuita no produto esta comprimindo margens em toda a industria - favorecendo gigantes e dificultando competicao de mid-market ISVs." 35 358 890 38 12 $cBranco $false 1 | Out-Null

# ===== SLIDE 15 - CENARIO A =====
$s = $slides.Add(15, 12)
Header $s "BLOCO 4  |  CENARIOS 3-5 ANOS (10 min)" "Cenario A - A Consolidacao Acelerada"

Rect   $s 20 118 80 28 $cAcento | Out-Null
TBox   $s "PROB." 20 122 80 20 9 $cBranco $true 2 | Out-Null
Rect   $s 108 118 280 28 (BGR 0x2A 0x10 0x20) | Out-Null
TBox   $s "Moderada-Alta" 108 122 280 20 12 $cAcento $true 1 | Out-Null

TBox   $s "Os grandes players (Microsoft, Google, Salesforce, SAP) incorporam IA como feature padrao e consolidam market share. ISVs de mid-market sem diferenciacao sao adquiridos ou ficam obsoletos." 20 158 920 48 13 $cBranco $false 1 | Out-Null

Rect   $s 20 218 440 148 (BGR 0x0A 0x1A 0x0A) | Out-Null
TBox   $s "VENCEDORES" 30 226 420 22 12 $cVerde $true 1 | Out-Null
TBox   $s ">  Hyperscalers e plataformas horizontais`n>  Verticais com dados proprietarios unicos`n>  Players com moat regulatorio forte" 30 250 420 100 12 $cBranco $false 1 | Out-Null

Rect   $s 480 218 460 148 (BGR 0x1A 0x0A 0x0A) | Out-Null
TBox   $s "PERDEDORES" 490 226 440 22 12 $cAcento $true 1 | Out-Null
TBox   $s ">  Software generico sem moat de dados`n>  Ferramentas ponto-a-ponto sem integracao`n>  Mid-market ISVs sem diferenciacao clara" 490 250 440 100 12 $cBranco $false 1 | Out-Null

TBox   $s "Mercado encolhe em numero de empresas, mas cresce em valor agregado por empresa." 20 385 920 38 13 $cAmarelo $false 1 | Out-Null

# ===== SLIDE 16 - CENARIO B =====
$s = $slides.Add(16, 12)
Header $s "BLOCO 4  |  CENARIOS 3-5 ANOS" "Cenario B - A Explosao do Software Vertical"

Rect   $s 20 118 80 28 $cVerde | Out-Null
TBox   $s "PROB." 20 122 80 20 9 $cFundo $true 2 | Out-Null
Rect   $s 108 118 200 28 (BGR 0x0A 0x2A 0x1A) | Out-Null
TBox   $s "Moderada" 108 122 200 20 12 $cVerde $true 1 | Out-Null

TBox   $s "IA reduz drasticamente o custo de criacao de software especializado - mil novos ISVs verticais emergem. Cada industria passa a ter multiplos players de IA nativa ultra-especializados." 20 158 920 48 13 $cBranco $false 1 | Out-Null

Rect   $s 20 218 440 148 (BGR 0x0A 0x1A 0x0A) | Out-Null
TBox   $s "VENCEDORES" 30 226 420 22 12 $cVerde $true 1 | Out-Null
TBox   $s ">  Fundadores com profundo dominio setorial`n>  Plataformas de infraestrutura de IA`n>  Venture capital focado em vertical AI" 30 250 420 100 12 $cBranco $false 1 | Out-Null

Rect   $s 480 218 460 148 (BGR 0x1A 0x0A 0x0A) | Out-Null
TBox   $s "PERDEDORES" 490 226 440 22 12 $cAcento $true 1 | Out-Null
TBox   $s ">  Software horizontal sem especializacao`n>  Players que apostam em generalismo`n>  ISVs lentos para pivotar para vertical AI" 490 250 440 100 12 $cBranco $false 1 | Out-Null

TBox   $s "O mercado cresce em numero de empresas e em total addressable market." 20 385 920 38 13 $cAmarelo $false 1 | Out-Null

# ===== SLIDE 17 - CENARIO C =====
$s = $slides.Add(17, 12)
Header $s "BLOCO 4  |  CENARIOS 3-5 ANOS" "Cenario C - A Plataformizacao Total"

Rect   $s 20 118 80 28 $cAmarelo | Out-Null
TBox   $s "PROB." 20 122 80 20 9 $cFundo $true 2 | Out-Null
Rect   $s 108 118 420 28 (BGR 0x2A 0x2A 0x00) | Out-Null
TBox   $s "Baixa-Moderada  |  ALTO IMPACTO se ocorrer" 108 122 420 20 12 $cAmarelo $true 1 | Out-Null

TBox   $s "Modelos de fundacao se tornam a camada de aplicacao - empresas compram inteligencia diretamente de OpenAI, Anthropic ou Google. Software de negocio reduzido a orquestracao e customizacao." 20 158 920 48 13 $cBranco $false 1 | Out-Null

Rect   $s 20 218 440 148 (BGR 0x0A 0x1A 0x0A) | Out-Null
TBox   $s "VENCEDORES" 30 226 420 22 12 $cVerde $true 1 | Out-Null
TBox   $s ">  Provedores de modelos de fundacao`n>  Empresas com dados unicos e defensaveis`n>  Infraestrutura de cloud" 30 250 420 100 12 $cBranco $false 1 | Out-Null

Rect   $s 480 218 460 148 (BGR 0x1A 0x0A 0x0A) | Out-Null
TBox   $s "PERDEDORES" 490 226 440 22 12 $cAcento $true 1 | Out-Null
TBox   $s ">  A industria de software de aplicacao`n   como a conhecemos hoje`n>  ISVs sem dados proprietarios unicos" 490 250 440 100 12 $cBranco $false 1 | Out-Null

TBox   $s "Valor migra radicalmente para dados proprietarios e infraestrutura de compute." 20 385 920 38 13 $cAmarelo $false 1 | Out-Null

# ===== SLIDE 18 - SINAIS ALERTA =====
$s = $slides.Add(18, 12)
Header $s "BLOCO 4  |  CENARIOS 3-5 ANOS" "Sinais de Alerta para Monitorar em 2025-2026"

$sinais = @(
    @("01", "Evolucao do pricing de SaaS", "Surgimento de modelos outcome-based em contratos enterprise = sinal de ruptura estrutural"),
    @("02", "Aquisicoes de ISVs por modelos de fundacao", "Se OpenAI ou Anthropic comprarem software vertical, o sinal sera claro"),
    @("03", "NRR da industria abaixo de 100%", "Se cair onde IA foi amplamente adotada, e evidencia de canibalizacao real"),
    @("04", "Churn para solucoes IA nativas", "Cursor vs. Copilot vs. IDE tradicional e o laboratorio observavel hoje"),
    @("05", "Consolidacao de devtools", "O padrao que emergir definira como software e construido na proxima decada")
)
$y = 118
foreach ($sinal in $sinais) {
    Rect $s 20 $y 40 34 (BGR 0x2A 0x1A 0x2A) | Out-Null
    TBox $s $sinal[0] 20 ($y+4) 40 24 12 $cAcento $true 2 | Out-Null
    TBox $s $sinal[1] 68 ($y+3) 490 18 12 $cBranco $true 1 | Out-Null
    TBox $s $sinal[2] 68 ($y+20) 840 17 11 $cCinza $false 1 | Out-Null
    $y += 44
}

# ===== SLIDE 19 - QUESTOES DEBATE =====
$s = $slides.Add(19, 12)
Header $s "BLOCO 5  |  QUESTOES PARA DEBATE (10 min)" "As Perguntas Que a Industria Ainda Nao Respondeu"

$temas = @(
    @("ESTRATEGIA`nDE PRODUTO", "O produto incorpora IA como feature ou como arquitetura? Quando o cliente pode montar o software com agentes, qual e o plano B?"),
    @("MODELOS DE`nNEGOCIO", "Voce esta preparado para defender margem quando custos sobem e mercado pressiona por outcome-based pricing?"),
    @("M&A E`nINVESTIMENTO", "Multiplos AI-native precificam execucao ou expectativa? Software vertical e investivel dado risco de plataformizacao?"),
    @("TALENTO E`nORGANIZACAO", "O dev de 2030 vai programar ou orquestrar agentes? Lideranca foi desenhada para o mundo de software gerado por IA?"),
    @("REGULACAO`nE CONFIANCA", "Quem responde quando IA erra em decisoes criticas? Como EUA, Europa e Brasil divergindo afeta produto e M&A cross-border?")
)
$x = 20
$w = 175
foreach ($tema in $temas) {
    Rect $s $x 118 $w 310 $cCard | Out-Null
    Rect $s $x 118 $w 6 $cAcento | Out-Null
    TBox $s $tema[0] ($x+5) 130 ($w-10) 40 10 $cVerde $true 1 | Out-Null
    TBox $s $tema[1] ($x+5) 180 ($w-10) 235 11 $cCinza $false 1 | Out-Null
    $x += ($w + 11)
}

# ===== SLIDE 20 - HISTORICO =====
$s = $slides.Add(20, 12)
Header $s "BLOCO 6  |  ENCERRAMENTO (5 min)" "O Que a Historia Nos Ensina - E Onde Ela Nao Ajuda"

Rect   $s 20 116 920 30 (BGR 0x2A 0x2A 0x4A) | Out-Null
TBox   $s "Disrupcao" 20 120 290 22 11 $cCinza $true 1 | Out-Null
TBox   $s "Adaptaram" 320 120 290 22 11 $cVerde $true 1 | Out-Null
TBox   $s "Desapareceram" 620 120 300 22 11 $cAcento $true 1 | Out-Null

$historico = @(
    @("Client-server > Web", "Microsoft, Oracle (custoso, mas sobreviveram)", "Lotus, Netscape, WordPerfect", $cCard),
    @("On-premise > Cloud",  "SAP, Adobe, Microsoft",                          "ISVs que nao fizeram a transicao", $cCard),
    @("Mobile",              "Adaptacao ampla, poucos desapareceram",           "Ferramentas desktop especializadas", $cCard),
    @("IA GENERATIVA",       "A ser escrito...",                                "A ser escrito...", (BGR 0x2A 0x0A 0x1A))
)
$y = 150
foreach ($h in $historico) {
    Rect $s 20 $y 920 46 $h[3] | Out-Null
    $tc = if ($h[0] -like "*IA*") { $cAmarelo } else { $cBranco }
    TBox $s $h[0] 25 ($y+7) 285 34 12 $tc $true 1 | Out-Null
    TBox $s $h[1] 325 ($y+7) 285 34 11 $cVerde $false 1 | Out-Null
    TBox $s $h[2] 625 ($y+7) 300 34 11 $cAcento $false 1 | Out-Null
    $y += 50
}

TBox   $s "A diferenca desta vez: velocidade e profundidade sem paralelo. Nas transicoes anteriores havia tempo para aprender e pivotar. A janela agora e significativamente menor." 20 408 920 38 12 $cBranco $false 1 | Out-Null

# ===== SLIDE 21 - FINAL =====
$s = $slides.Add(21, 12)
SetBg  $s $cEscuro
Rect   $s 0 0 960 6 $cAcento | Out-Null
Rect   $s 0 534 960 6 $cAcento | Out-Null
TBox   $s "Em 2030, o seu negocio vendera" 0 75 960 50 26 $cCinza $false 2 | Out-Null
TBox   $s "software com IA" 0 125 960 65 46 $cBranco $true 2 | Out-Null
TBox   $s "- ou -" 0 192 960 34 18 $cCinzaEsc $false 2 | Out-Null
TBox   $s "inteligencia com software?" 0 226 960 65 46 $cAcento $true 2 | Out-Null
Linha  $s 280 302 400 $cAcento 2
TBox   $s "A resposta que voce der hoje pode ser a decisao estrategica mais importante da proxima decada." 80 318 800 65 16 $cCinza $false 2 | Out-Null

# ===== SALVAR =====
$pres.SaveAs($outputPath)
Write-Output "OK: PPT salvo em $outputPath"
$pres.Close()
$ppt.Quit()
