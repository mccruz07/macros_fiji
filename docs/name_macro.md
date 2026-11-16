# name_macro — copiar labels para um stack de máscaras

[← README](../README.md) · [Código](../name_macro.ijm)

## Para que serve

Copiar o label de cada slice de um stack de origem para o slice de mesmo índice de um stack de destino, acrescentando `_mask`. A intenção é manter a correspondência entre imagens e máscaras pelos labels.

**Não calcula máscaras, não altera pixels e não salva arquivos.** Modifica os metadados dos slices do stack de destino aberto.

## O que precisa estar aberto

| Variável | Título fixo no código | Papel |
| --- | --- | --- |
| orig | TEM_mito.tif | Stack com os labels originais |
| dest | mito_maks_final.tif | Stack que receberá os labels |

Edite esses títulos para corresponder exatamente às janelas da sua sessão. A grafia `maks` está no original e foi preservada. Os dois stacks precisam estar na mesma ordem, e o destino deve conter pelo menos o número de slices da origem.

## Como funciona

Seleciona a origem, obtém `nSlices` e, para cada índice, lê `getInfo("slice.label")`. Em seguida seleciona o destino, remove ocorrências de `.tiff` e `.tif` do texto e grava o label acrescido de `_mask`. Retorna à origem a cada iteração.

Exemplo simples: `campo01.tif` → `campo01_mask`.

## Cuidados de reutilização

Não compara pixels, dimensões ou correspondência entre slices. Em hyperstacks, percorre índices de slices sem um tratamento explícito de C/Z/T. Labels vazios, repetidos ou com várias linhas são copiados conforme o processamento de texto. `_mask` é acrescentado sempre: executar novamente usando uma origem já terminada em `_mask` pode produzir `_mask_mask`.

Os labels existentes no destino são substituídos. Para guardar o resultado, salve o stack pelo Fiji/ImageJ ou use uma rotina de exportação depois de conferir os nomes.

## Relação com as outras macros

Pode anteceder [slip_save_Macro](slip_save_Macro.md), que separa um stack e salva imagens usando os títulos gerados. Confirme primeiro como Stack to Images transforma os labels em títulos na sua instalação.
