# LifToTif — separar séries e canais de arquivos LIF

[← README](../README.md) · [Código](../LifToTif.ijm)

## Para que serve

Rotina de conversão em lote de arquivos Leica `.lif` para TIFFs separados por série e canal. Não faz projeção Z nem merge; a intenção é salvar cada canal com as dimensões Z/T que forem importadas.

## O que precisa

Fiji/ImageJ com Bio-Formats Importer e Bio-Formats Macro Extensions. A macro pede uma pasta de entrada e uma pasta de saída. Percorre apenas o primeiro nível da pasta e aceita a extensão literal `.lif`, em minúsculas.

Execute em uma sessão sem outras imagens abertas: a rotina enumera todas as imagens da sessão e usa `Close All` ao final de cada série.

## O que acontece, passo a passo

1. Ativa modo batch e as extensões Bio-Formats.
2. Para cada LIF, consulta o número de séries.
3. Percorre índices de 0 até número de séries menos 1 e solicita a importação como hyperstack XYCZT.
4. Obtém um nome de série pelas extensões e executa `Split Channels`.
5. Usa `nImages` como número de canais e salva cada janela por índice.
6. Fecha todas as imagens antes de avançar.

## Arquivos gerados

```text
<base do LIF>_series<índice>_<nome da série>_ch<índice da janela>.tif
```

Exemplo de nome pretendido: `amostra_series0_Campo1_ch1.tif`. Todos os TIFFs vão diretamente para a pasta escolhida. A variável `savePath` sugere uma subpasta por LIF, mas não é usada para criá-la ou salvar.

## O que conferir antes de reutilizar

- O laço começa em zero e monta `series_0`, `series_1` etc. Confira a convenção de seleção de séries do Importer na versão instalada; não presuma que esse índice abre a mesma série das extensões.
- Não há `Ext.setSeries(l)` antes de `Ext.getSeriesName`. O nome obtido pelas extensões pode não corresponder à série aberta pelo Importer.
- O número e a ordem de imagens abertas não são uma identificação segura dos canais. Imagens preexistentes podem ser salvas como se fossem canais e depois fechadas.
- O nome de série não é limpo para uso no sistema de arquivos. Nomes repetidos também podem colidir no destino.
- Não há conversão explícita para RGB ou redução explícita da profundidade de bits; confira o tipo de pixel e C/Z/T reabrindo o TIFF.

## Relação com as outras macros

É a variante simples de exportação por canal. [LifToTiff_zproject_merge](LifToTiff_zproject_merge.md) acrescenta escolhas de projeção máxima, merge e salvamento individual. Ambas são mantidas para consulta, sem afirmar equivalência de resultados.
