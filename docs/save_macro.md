# save_macro — separar e salvar um stack em um caminho fixo

[← README](../README.md) · [Código](../save_macro.ijm)

## Para que serve

Selecionar um stack pelo título, executar Stack to Images e salvar as imagens abertas como TIFF, fechando cada uma depois de salvar.

## Ajustes necessários

- `orig` está fixado em `mito_maks_final.tif`. Troque pelo título exato da janela de entrada.
- `outDir` contém um caminho absoluto de uma sessão Windows do autor. Troque por uma pasta existente no seu computador.
- O código concatena `outDir + name` e o caminho fornecido não termina em separador. Corrija a construção do caminho antes de executar, para não produzir um nome fora da pasta pretendida. Usar uma seleção de diretório é uma possível adaptação, mas não foi aplicada ao original.
- Confira também a representação das barras do caminho como string de macro, em vez de reutilizar diretamente o caminho antigo.

## Passo a passo do código

Seleciona o stack, separa seus slices em imagens e guarda `nImages`. Percorre as janelas do último índice até o primeiro, obtém o título, remove `.tiff` e `.tif`, salva TIFF e fecha a janela.

O contador é o número de **todas as imagens abertas após a separação**, não apenas das que vieram do stack. Imagens que já estavam abertas podem ser salvas e fechadas também.

## Nomes e saída

O caminho passado a saveAs é a concatenação direta da pasta e do título limpo. Não acrescenta `_mask` por conta própria. Se os títulos vierem dos labels do stack, a nomenclatura dependerá desses labels e de como Stack to Images os converte.

Nomes repetidos podem apontar para o mesmo destino. Não há criação de pasta, tratamento explícito de erro ou proteção contra colisões.

## Relação com as outras macros

É um trecho com janela e destino fixos. [slip_save_Macro](slip_save_Macro.md) pede a pasta ao usuário, trabalha com o stack ativo e tenta garantir o sufixo `_mask`, mas tem diferenças na seleção e limpeza dos nomes.
