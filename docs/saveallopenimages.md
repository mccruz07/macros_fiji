# saveallopenimages.ijm

[← README](../README.md) · [Código](../saveallopenimages.ijm)

## Objetivo

Salvar as imagens abertas no Fiji como TIFF em uma pasta escolhida e, ao concluir o laço, executar `Close All`.

## Entradas e requisitos

- Fiji / ImageJ com uma ou mais imagens abertas.
- Uma pasta de destino com permissão de gravação.

Não exige Bio-Formats diretamente e não pede uma pasta de entrada. A seleção é feita a partir das imagens já abertas, inclusive stacks ou hyperstacks que estejam nessa sessão.

## Uso

1. Abra somente as imagens que pretende salvar e confira seus títulos.
2. Execute a macro no editor.
3. Selecione o destino em **Choose a Directory**.
4. A macro percorre as imagens por índice, imprime cada título no Log e chama `saveAs("tiff", dir+title)`.
5. Ao terminar, fecha todas as imagens. Reabra os TIFFs para conferir o resultado.

Não há opção para selecionar um subconjunto ou manter as janelas abertas.

## Saídas

Um salvamento TIFF por imagem percorrida. O nome é construído a partir do título da janela, sem normalização explícita de extensões ou caracteres.

Por exemplo, um título `amostra` é usado como base de saída `amostra` no diretório escolhido, com formato TIFF. Confira os nomes finais quando os títulos já contiverem extensões.

## Limitações e cuidados

- Títulos iguais ou nomes já existentes no destino podem causar colisões; não há política explícita para evitar substituições.
- `Close All` afeta todas as imagens abertas ao final, incluindo imagens que talvez você pretendesse manter na sessão.
- A macro não verifica a integridade do TIFF antes de fechar as imagens.
- Não há tratamento explícito de falhas de gravação ou destinos sem permissão.
- A quantidade `nImages` é consultada na condição do laço; o código pressupõe que a coleção de imagens não seja alterada durante o salvamento.
- Salvar como TIFF não garante reproduzir todos os metadados do formato de origem.

## Autoria

O arquivo fornecido não contém autoria ou data de atualização no cabeçalho.
