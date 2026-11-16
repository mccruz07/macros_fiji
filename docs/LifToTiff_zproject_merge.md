# LifToTiff_zproject_merge — LIF com projeção e merge opcionais

[← README](../README.md) · [Código](../LifToTiff_zproject_merge.ijm)

## Para que serve

Converter séries de arquivos `.lif`, separar os canais e, opcionalmente, produzir projeções de intensidade máxima em Z e uma imagem combinada. É a variante com mais opções entre os conversores LIF deste acervo.

## Entradas e escolhas

Requer Fiji/ImageJ com Bio-Formats Importer e Macro Extensions, pasta de entrada e pasta de saída. Somente arquivos `.lif` em minúsculas no primeiro nível são considerados.

| Pergunta | Quando marcada |
| --- | --- |
| Fazer Z projection (Max Intensity)? | Aplica projeção máxima se a série tiver mais de um plano Z |
| Fazer merge dos canais? | Executa Merge Channels e salva a imagem combinada |
| Salvar canais individuais? | Salva cada canal processado separadamente |

Se merge e salvamento individual estiverem desativados, **nenhum TIFF é salvo**, mesmo que a projeção seja calculada.

## Como funciona

A macro consulta as séries, importa cada uma como hyperstack, solicita o nome via `Ext.setSeries(s)` e substitui caracteres de caminho no nome. Lê C/Z/T, divide os canais e procura janelas cujo título começa com `C1-`, `C2-` etc. Cada canal é projetado ou mantido; os títulos resultantes são usados para montar o comando de merge. Ao final de cada série, executa `Close All`. Desativa modo batch ao terminar normalmente.

A projeção máxima reduz a dimensão Z ao selecionar a maior intensidade por posição. A macro não especifica uma estratégia explícita para todos os tempos em séries T>1; confira o comportamento da instalação antes de processar time-lapse.

## Saídas

```text
<base>_series<s>_<nome>_C<canal>_RAW.tif
<base>_series<s>_<nome>_C<canal>_MAX.tif
<base>_series<s>_<nome>_MERGE_RAW.tif
<base>_series<s>_<nome>_MERGE_MAX.tif
```

O sufixo depende da opção de projeção, não da sua execução efetiva: uma série com Z=1 também recebe `_MAX` se a opção estiver marcada. `_RAW` significa ausência de projeção nesta macro; não garante preservação integral dos metadados do LIF.

O merge usa a opção `create`; não há comando explícito de conversão RGB. Confira canais e tipo de imagem do TIFF combinado, sem presumir que é uma imagem RGB achatada.

## Uso para consulta e reutilização

Abra a macro, escolha as pastas e as três opções. Use uma sessão sem imagens alheias ao processamento. Reabra os TIFFs e confira os canais, os planos, os tempos e os nomes de série.

## Pontos específicos para conferir

- O Importer recebe `series_` com índice iniciado em zero. Verifique a correspondência com a série selecionada pelas extensões antes de confiar no conteúdo/nome.
- A busca de canais considera todas as janelas e apenas o prefixo do título; uma janela de outra imagem com o mesmo prefixo pode ser escolhida.
- Se um canal não for encontrado, o script registra a ocorrência e continua. A ausência pode comprometer o merge; não há exigência de que todos os canais estejam presentes.
- Imagens de um só canal podem não receber o título esperado após Split Channels. Teste esse caso separadamente.
- O fechamento é chamado com `close(channelID)`; confira a compatibilidade dessa chamada no interpretador usado e se a imagem correta é fechada.
- Os títulos são armazenados antes de `saveAs`. Se o salvamento alterar o título da janela na instalação, o merge pode procurar um título antigo.
- O comando de merge é montado com um campo por canal, sem validar os limites aceitos pelo comando instalado.
- Não há política explícita de nomes únicos ou recuperação após falha. `Close All` também afeta imagens que já estavam abertas.
