PImage img;
PImage sorted;
int stop = 0;
int width = 0;
int height = 0;

long startTime = 0; //measure the speed of sorting process


//select how to sort the pixels by hue or brightness
String sortPixelMethod = "hue";
//String sortPixelMethod = "brightness";


String filename;
//there is no file validation, so any non-img selected will crash the program
void fileSelected(File selection) {
  if (selection == null) {
    println("No image file selected.");
    exit();
  } else {
    String filepath = selection.getAbsolutePath();
    filename = selection.getName();
    int pos = filename.lastIndexOf(".");
    if (pos != -1) filename = filename.substring(0, pos);
    println("File selected " + filepath);
    // load file here
    img = loadImage(filepath);
  }
}

void interrupt() { 
      while (img==null) delay(200); 
}

//set initial canvas size
void settings() {
  selectInput("Select an image file to process:", "fileSelected");
  interrupt(); //interrupt process until img is selected
  
  //for testing
  //img = loadImage("sunflower400.jpg");
  //img = loadImage("Colorful1.jpg");
  //img = loadImage("Smoke.jpg");
  width = img.width;
  height = img.height;
  
  //the canvas window size will be according to the img size
  //if the img is bigger, it will be resized to 80% of display
  if (width > displayWidth) {
    float resizer = width / (displayWidth * 0.8);
    width = (int)((float)displayWidth * 0.8);
    height = (int)((float)height / resizer); 
    img.resize(width, height);
  }
  if (height > displayHeight) {
    float resizer = height / (displayHeight * 0.8);
    height = (int)((float)displayHeight * 0.8);
    width = (int)((float)width / resizer);
    img.resize(width, height);
  }
  size(width, height);
}

void setup() {
  sorted = createImage(img.width, img.height, HSB);
  sorted = img.get();
  background(0);
  image(sorted, 0, 0);
  
  startTime = System.currentTimeMillis();
}

void draw() {

  sorted.loadPixels();
  
  if (stop == 0) {
    stop++;
    quickSort(0, sorted.pixels.length-1);
  }
  
  //show sorted pixels img
  sorted.updatePixels();
  background(0);
  image(sorted, 0, 0);
  
  if (stop == 1) {
    noLoop();
    save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
    println("pixels sorting complete in "+(System.currentTimeMillis() - startTime)+" milisecs / sort by " + sortPixelMethod);
  }
  
}

//http://www.java2novice.com/java-sorting-algorithms/quick-sort/
void quickSort(int lowerIndex, int higherIndex) {
  float pivotPix = 0;
  int i = lowerIndex;
  int j = higherIndex;
  // calculate pivot number, I am taking pivot as middle index number
  int pivot = sorted.pixels[lowerIndex+(higherIndex-lowerIndex)/2]; //pixel values
  
  //sort either by hue or brightness;
  if (sortPixelMethod.equals("brightness")) pivotPix = brightness(pivot);
  else if (sortPixelMethod.equals("hue")) pivotPix = hue(pivot);
  
  // Divide into two sorted.pixels arrays
  while (i <= j) {
    
    /**
     * In each iteration, we will identify a number from left side which 
     * is greater then the pivot value, and also we will identify a number 
     * from right side which is less then the pivot value. Once the search 
     * is done, then we exchange both numbers.
     */
    //sort either by hue or brightness;
    if (sortPixelMethod.equals("brightness")) {
      
      while (brightness(sorted.pixels[i]) > pivotPix) i++;
      while (brightness(sorted.pixels[j]) < pivotPix) j--;
      
    } else if (sortPixelMethod.equals("hue")) {
      
      while (hue(sorted.pixels[i]) > pivotPix) i++;
      while (hue(sorted.pixels[j]) < pivotPix) j--;
      
    }
    if (i <= j) {
        exchangePixel(i, j);
        //move index to next position on both sides
        i++;
        j--;
    }
  }
  // call quickSort() method recursively
  if (lowerIndex < j) {
      quickSort(lowerIndex, j);
  }
  if (i < higherIndex) {
      quickSort(i, higherIndex);
  }
}

void exchangePixel(int i, int j) {
  color temp = sorted.pixels[i];
  sorted.pixels[i] = sorted.pixels[j];
  sorted.pixels[j] = temp;
}
