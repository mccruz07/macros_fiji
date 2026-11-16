orig = "mito_maks_final.tif";
outDir = "D:\zeiss\Desktop\Wagner_images\Mito_analysis\final";

selectWindow(orig);
run("Stack to Images");

n = nImages;

for (i = n; i >= 1; i--) {
selectImage(i);
name = getTitle();


	name = replace(name, ".tiff", "");
	name = replace(name, ".tif", "");
	
	saveAs("Tiff", outDir + name);
	close();


}
