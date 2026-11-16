inputDir = getDirectory("Get input directory");
outputDir = getDirectory("Get output directory");
fs = File.separator;
allFiles = getFileList(inputDir);
setBatchMode(true);

run("Bio-Formats Macro Extensions");

for (f = 0; f < allFiles.length; f++) {
    if (endsWith(allFiles[f], ".lif")) {
        fileName = allFiles[f];
        filePath = inputDir + fileName;
        savePath = outputDir + fileName + fs;

        // Conta o número de séries
        Ext.setId(filePath);
        Ext.getSeriesCount(seriesCount);
        sCount = seriesCount;

        for (l = 0; l < sCount; l++) {
            // Abre a série l
            run("Bio-Formats Importer", 
                "open=[" + filePath + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_" + l);

            // Recupera nome da série
            Ext.getSeriesName(seriesName);

            // Divide os canais
            run("Split Channels");

            // Salva cada canal separadamente
            nChannels = nImages;
            for (ch = 1; ch <= nChannels; ch++) {
                selectImage(ch);
                imgTitle = getTitle();
                // nome base do arquivo sem extensão
				baseName = File.getNameWithoutExtension(fileName); // Corrigido!

				saveName = baseName + "_series" + l + "_" + seriesName + "_ch" + ch + ".tif";
				saveAs("Tiff", outputDir + saveName);
            }
            run("Close All");
        }
    }
}
print("Finished!");