# czitotiff.ijm

[← README](../README.md) · [Código](../czitotiff.ijm)

## Objetivo

Importar as séries de arquivos Zeiss CZI e salvar cada série como TIFF. O código consulta a quantidade de séries com Bio-Formats e usa um campo de metadados da cena para compor o nome de saída.

## Requisitos e entradas

- Fiji com Bio-Formats Importer e Bio-Formats Macro Extensions.
- Pasta de entrada com arquivos `.czi` em minúsculas.
- Pasta de saída existente, escolhida pelo usuário.
- Metadado `Information|Image|S|Scene|Name #N` disponível, ou tratamento alternativo a implementar.

A varredura usa `getFileList` e não é recursiva.

## Opções e uso

1. Abra a macro no editor do Fiji e execute.
2. Em **Get input directory**, selecione a pasta de entrada.
3. Em **Get outputdirectory**, selecione a pasta de saída.
4. A macro consulta a quantidade de séries de cada arquivo e solicita sua importação uma a uma.
5. Verifique os TIFFs e a mensagem `Finished!` no Log; a mensagem isoladamente não comprova que todas as séries foram exportadas corretamente.

Não há escolha de série no diálogo: o laço percorre de 1 até o número de séries reportado. A importação solicita `autoscale`, `color_mode=Default`, `view=Hyperstack` e `stack_order=XYCZT`.

## Saídas

O caminho passado a `saveAs` é:

```text
<pasta de saída>/<File.nameWithoutExtension>_<valor do metadado de cena>
```

O formato solicitado é TIFF. Exemplo ilustrativo, caso a base seja `amostra` e o metadado seja `Cena1`: `amostra_Cena1.tif`.

O nome base vem de `File.nameWithoutExtension` após a importação; confirme seu valor no ambiente utilizado. O índice da série não é incluído explicitamente no nome final.

**A macro não força RGB:** a linha `run("RGB Color")` está comentada, embora o cabeçalho mencione TIFF colorido. Confira canais, tipo de pixel e cores após exportar.

## Limitações identificadas

- O `if (endsWith(..., ".czi"))` não tem chaves. Apenas a atribuição de `fileName` depende da extensão; o processamento seguinte acontece para todas as entradas. Um item incompatível pode usar um nome anterior ou uma variável ainda não definida.
- A extensão é comparada literalmente; `.CZI` não é reconhecida pela condição.
- O campo de cena pode estar ausente ou ter valores repetidos/inadequados para nomes de arquivo. Não há alternativa nem limpeza desses nomes.
- Séries com o mesmo nome podem apontar para o mesmo destino. Não há política explícita contra colisões.
- As imagens importadas não são fechadas explicitamente após salvar, o que pode aumentar o uso de memória.
- Não há tratamento de erros de leitura, metadados ou gravação.
- `savePath` e `series` são calculados, mas não determinam o caminho usado para salvar.
- Não há garantia implementada de preservação integral dos metadados do CZI em TIFF.

## Autoria no arquivo

Mario Cruz; Cimini’s Lab, Broad Institute of MIT and Harvard. Última atualização declarada: 29/07/2022.
