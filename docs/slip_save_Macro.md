# slip_save_Macro — separar stack e salvar imagens com sufixo _mask

[← README](../README.md) · [Código](../slip_save_Macro.ijm)

## Para que serve

Separar o stack ativo em imagens individuais e salvá-las em uma pasta escolhida, usando os títulos das janelas e acrescentando `_mask.tif` quando o nome não termina em `_mask`.

Não segmenta a imagem e não produz uma máscara nova: o sufixo é apenas uma convenção de nome para imagens que já devem representar as máscaras desejadas.

## Entradas e uso

1. Abra o stack a exportar e deixe-o ativo.
2. Confira a ordem e os labels dos slices. Feche outras imagens para evitar ambiguidade na seleção por índice.
3. Execute a macro e escolha a pasta de saída.
4. Confira os TIFFs gerados, nomes e correspondência com os slices originais.

Não depende explicitamente de Bio-Formats.

## O que acontece

Guarda `nSlices`, executa Stack to Images e repete esse número de vezes: seleciona a imagem de índice `nImages()`, obtém seu título, limpa extensões, define o nome de saída, salva TIFF e fecha a imagem. A rotina trabalha pelos índices das imagens abertas; não guarda uma lista de IDs das imagens originadas do stack.

## Exemplos de nomes pretendidos

| Título da imagem | Nome salvo |
| --- | --- |
| campo01.tif | campo01_mask.tif |
| campo01_mask | campo01_mask.tif |

**Particularidade do código:** remove `.tif` antes de `.tiff`. Assim, um título `campo01.tiff` pode virar `campo01f` e ser salvo como `campo01f_mask.tif`. A limpeza não é restrita ao final do texto. Confira extensões e nomes antes de usar em lote.

## Limitações

O comentário diz que preserva labels, mas o código lê títulos das imagens após a separação, não os labels originais diretamente. Essa correspondência depende de Stack to Images. Nomes vazios, repetidos, caracteres inadequados e imagens abertas fora do stack não são tratados explicitamente.

A macro não cria um sufixo único para colisões nem verifica o arquivo antes de fechar a imagem. O uso de `nSlices` pressupõe um stack simples; para hyperstacks com C/Z/T, confira a quantidade e a ordem das imagens resultantes antes de exportar.

## Relação com name_macro

[name_macro](name_macro.md) pode preparar labels terminados em `_mask` no stack de destino. Depois, com esse stack ativo, esta macro pode exportá-lo. Confirme a nomenclatura em poucos slices antes de aplicar a sequência inteira.
