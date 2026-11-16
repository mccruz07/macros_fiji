# svstotiff.ijm

[← README](../README.md) · [Código](../svstotiff.ijm)

## Objetivo e estado atual

Abrir uma série escolhida de arquivos SVS, converter a imagem para RGB e salvá-la como TIFF.

**Estado:** revisão estática, sem execução. O código repete a série selecionada e contém um filtro incompleto de arquivos.

## Requisitos e entradas

- Fiji com Bio-Formats Importer e Bio-Formats Macro Extensions.
- Pasta com arquivos `.svs` em minúsculas; a busca não é recursiva.
- Pasta de saída existente.
- Memória compatível com a série selecionada, especialmente em imagens de lâmina inteira.

## Parâmetros e uso

| Janela / campo | Significado | Padrão |
| --- | --- | --- |
| `Get input directory` | Pasta com arquivos SVS | Escolhido pelo usuário |
| `Choose which Series?` | Número da série solicitado ao Bio-Formats, contado a partir de 1 | `4` |
| `Get outputdirectory` | Pasta para salvar TIFFs | Escolhido pelo usuário |

1. Confira manualmente quais séries existem no SVS e qual corresponde à imagem desejada.
2. Execute a macro e selecione a entrada.
3. Informe a série e selecione a saída.
4. Inspecione o TIFF exportado e suas dimensões.

O mesmo número de série é usado para todos os arquivos. Não presuma que uma série representa sempre a mesma resolução ou o mesmo tipo de imagem em diferentes SVS.

## Processamento e saídas

A macro consulta a contagem de séries, importa com `autoscale`, `color_mode=Default`, `view=Hyperstack` e `stack_order=XYCZT`, executa `RGB Color` e salva TIFF.

Padrão do nome passado a `saveAs`:

```text
<pasta de saída>/<File.nameWithoutExtension>_series_<S>
```

Exemplo ilustrativo: `lamina_series_4.tif`.

A conversão RGB muda a representação da imagem. Confira a adequação dessa saída para análise quantitativa e a preservação da calibração necessária ao seu trabalho.

## Limitações identificadas

- Sem chaves no `if`, somente a atribuição de `fileName` é condicional. Entradas incompatíveis também alcançam a importação, podendo reutilizar o arquivo anterior ou encontrar a variável indefinida.
- `.SVS` não é reconhecida pela comparação literal.
- O laço `l=1…sCount` importa sempre `series_S`, em vez de `series_l`. Assim, a mesma série é solicitada `sCount` vezes e salva no mesmo destino; pode haver sobrescrita ou interação de confirmação, conforme o ambiente.
- Não há validação de `S` como inteiro positivo dentro da quantidade de séries. `parseInt` não substitui essa validação.
- O código não fecha explicitamente cada imagem após exportar.
- Não há tratamento de falhas nem proteção explícita contra nomes repetidos.
- A contagem de séries pode variar entre arquivos; o padrão `4` não é universal.
- `savePath` é calculado, mas não é usado para salvar.

## Validação sugerida

Corrija o filtro e remova a repetição desnecessária se a intenção for exportar apenas uma série. Use um SVS pequeno ou uma série de dimensões reduzidas, compare com a importação manual e confirme um único resultado por arquivo. Teste série inexistente, pasta mista e arquivos com quantidades diferentes de séries.

## Autoria no arquivo

Mario Cruz; Cimini’s Lab, Broad Institute of MIT and Harvard. Última atualização declarada: 29/07/2022.
