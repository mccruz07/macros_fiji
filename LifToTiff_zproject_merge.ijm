// =====================================================
// CONFIGURAÇÕES
// =====================================================

inputDir = getDirectory("Pasta de entrada");
outputDir = getDirectory("Pasta de saída");
fs = File.separator;

// =====================================================
// OPÇÕES
// =====================================================

doZProjection = getBoolean(
    "Fazer Z projection (Max Intensity)?"
);

doMerge = getBoolean(
    "Fazer merge dos canais?"
);

saveChannels = getBoolean(
    "Salvar canais individuais?"
);

// =====================================================
// INICIALIZAÇÃO
// =====================================================

run("Bio-Formats Macro Extensions");
setBatchMode(true);

allFiles = getFileList(inputDir);

// =====================================================
// LOOP DOS ARQUIVOS
// =====================================================

for (i = 0; i < allFiles.length; i++) {

    if (!endsWith(allFiles[i], ".lif"))
        continue;

    fileName = allFiles[i];
    filePath = inputDir + fileName;

    baseName =
        File.getNameWithoutExtension(
            fileName
        );

    // -------------------------------------------------
    // Número de séries
    // -------------------------------------------------

    Ext.setId(filePath);
    Ext.getSeriesCount(seriesCount);

    numSeries = seriesCount;

    // =================================================
    // LOOP DAS SÉRIES
    // =================================================

    for (s = 0; s < numSeries; s++) {

        print("================================");
        print("Arquivo: " + fileName);
        print("Série: " + s);

        // ---------------------------------------------
        // Abrir série
        // ---------------------------------------------

        run(
            "Bio-Formats Importer",
            "open=[" + filePath + "] " +
            "autoscale " +
            "color_mode=Default " +
            "view=Hyperstack " +
            "stack_order=XYCZT " +
            "series_" + s
        );

        originalID = getImageID();
        selectImage(originalID);

        // ---------------------------------------------
        // Nome da série
        // ---------------------------------------------

        Ext.setSeries(s);
        Ext.getSeriesName(seriesName);

        bad = "\\/:*?\"<>|";

        for (c = 0;
             c < lengthOf(bad);
             c++) {

            seriesName = replace(
                seriesName,
                substring(
                    bad,
                    c,
                    c + 1
                ),
                "_"
            );
        }

        // ---------------------------------------------
        // Ler dimensões
        // ---------------------------------------------

        imgW = 0;
        imgH = 0;
        numChannels = 0;
        numZSlices = 0;
        numFrames = 0;

        getDimensions(
            imgW,
            imgH,
            numChannels,
            numZSlices,
            numFrames
        );

        print(
            "Canais encontrados: " +
            numChannels
        );

        print(
            "Slices Z: " +
            numZSlices
        );

        // ---------------------------------------------
        // Split dos canais
        // ---------------------------------------------

        run("Split Channels");

        idList =
            getList("image.titles");

        processedTitles =
            newArray(numChannels);

        // =============================================
        // PROCESSAR TODOS OS CANAIS
        // =============================================

        for (
            ch = 1;
            ch <= numChannels;
            ch++
        ) {

            channelID = -1;

            // -----------------------------------------
            // Encontrar canal
            // -----------------------------------------

            for (
                j = 0;
                j < idList.length;
                j++
            ) {

                title =
                    idList[j];

                if (
                    startsWith(
                        title,
                        "C" + ch + "-"
                    )
                ) {

                    selectImage(
                        title
                    );

                    channelID =
                        getImageID();

                    break;
                }
            }

            // Canal não encontrado
            if (
                channelID == -1
            ) {

                print(
                    "Canal C" +
                    ch +
                    " não encontrado"
                );

                continue;
            }

            selectImage(
                channelID
            );

            processedID =
                channelID;

            // -----------------------------------------
            // Z projection opcional
            // -----------------------------------------

            if (
                doZProjection &&
                numZSlices > 1
            ) {

                run(
                    "Z Project...",
                    "projection=[Max Intensity]"
                );

                processedID =
                    getImageID();

                close(
                    channelID
                );
            }

            selectImage(
                processedID
            );

            processedTitles[
                ch - 1
            ] =
                getTitle();

            // -----------------------------------------
            // Salvar canal individual
            // -----------------------------------------

            if (
                saveChannels
            ) {

                suffix =
                    "_RAW";

                if (
                    doZProjection
                ) {

                    suffix =
                        "_MAX";
                }

                saveName =
                    baseName +
                    "_series" +
                    s +
                    "_" +
                    seriesName +
                    "_C" +
                    ch +
                    suffix +
                    ".tif";

                saveAs(
                    "Tiff",
                    outputDir +
                    fs +
                    saveName
                );
            }
        }

        // =============================================
        // MERGE OPCIONAL
        // =============================================

        if (doMerge) {

            mergeCmd = "";

            for (
                ch = 1;
                ch <= numChannels;
                ch++
            ) {

                if (
                    processedTitles[
                        ch - 1
                    ] != ""
                ) {

                    mergeCmd +=
                        "c" +
                        ch +
                        "=[" +
                        processedTitles[
                            ch - 1
                        ] +
                        "] ";
                }
            }

            mergeCmd +=
                "create";

            print(
                mergeCmd
            );

            run(
                "Merge Channels...",
                mergeCmd
            );

            mergedID =
                getImageID();

            selectImage(
                mergedID
            );

            suffix =
                "_RAW";

            if (
                doZProjection
            ) {

                suffix =
                    "_MAX";
            }

            saveName =
                baseName +
                "_series" +
                s +
                "_" +
                seriesName +
                "_MERGE" +
                suffix +
                ".tif";

            saveAs(
                "Tiff",
                outputDir +
                fs +
                saveName
            );
        }

        // ---------------------------------------------
        // Limpeza
        // ---------------------------------------------

        run("Close All");
    }
}

// =====================================================
// FINALIZAÇÃO
// =====================================================

setBatchMode(false);

print("================================");
print("PROCESSAMENTO FINALIZADO");
print("================================");