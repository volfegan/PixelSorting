import java.util.Queue;
import java.util.LinkedList;

PImage img;
PImage sorted;
int width = 0;
int height = 0;


boolean showBothIMGs = false; //to show both imgs side by side, only sorted img
//select how to sort the pixels by hue or brightness
String sortPixelMethod = "hue";
//String sortPixelMethod = "brightness";


//used to control speed of sorting process
int multiStep = 1; //after 5s will change to 1000 steps
long startTime = 0;

//Create a queue stack to hold the quicksort indices to control the recursive calls
Queue<int[]> stackcalls = new LinkedList();
boolean started = false; //to mark if it started using stackcalls queue

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
    if (pos != -1) filename = filename.substring(0, pos); //remove extension
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
  //img = loadImage("tokyo.png");
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

  //the canvas window size will be according to the img size
  if (showBothIMGs && 2 * img.width < displayWidth)
    width = img.width * 2; //show both original and sorted pics if display is big enough
  size(width, height);
}

void setup() {
  //initial canvas size is set on settings
  
  textSize(18);
  sorted = createImage(img.width, img.height, HSB);
  sorted = img.get();
  
  //show original and sorted imgs
  background(0);
  if (showBothIMGs && 2 * img.width < displayWidth) {
    //2 img side by side
    image(img, 0, 0);
    image(sorted, img.width, 0);
  } else {
    //original img 20% in the corner
    image(sorted, 0, 0);
    if (!stackcalls.isEmpty()) {
      tint(255, 130);  // Apply transparency without changing color
      image(img, 0, 0.8* img.height, 0.2* img.width, 0.2* img.height);
      noTint();
    }
  }
}

void draw() {
  //show frame rate and current recursion stack queue
  println("Quicksort: " +String.format("%.2f", frameRate) + 
  " frameRate / steps to finish: " + stackcalls.size());
  
  sorted.loadPixels();
  
  //multiStep during each loop for faster sort
  for (int steps = 0; steps < multiStep; steps++) {
    //increase multistep after 5s to 1000 steps
    if (multiStep < 1000 && System.currentTimeMillis() > startTime + 5000) multiStep=1000;
    
    //control the quicksort recursive calls using the stackcalls queue
    if (stackcalls.isEmpty() && !started) {
      quickSort(0, sorted.pixels.length-1);
      started = true;
      delay(2000); //to have time to show the original img
      startTime = System.currentTimeMillis();
      
    } else if (!stackcalls.isEmpty()) {
      int[] indexes = stackcalls.remove();
      quickSort(indexes[0],indexes[1]);
    }
  
  }
  
  //show sorted pixels img so far
  sorted.updatePixels();
  //show original and sorted imgs
  background(0);
  if (showBothIMGs && 2 * img.width < displayWidth) {
    //2 img side by side
    image(img, 0, 0);
    image(sorted, img.width, 0);
  } else {
    //original img 20% in the corner
    image(sorted, 0, 0);
    if (!stackcalls.isEmpty()) {
      tint(255, 190);  // Apply transparency without changing color
      image(img, 0, 0.8* img.height, 0.2* img.width, 0.2* img.height);
      noTint();
    }
  }
  //Show framerate on display
  if (!stackcalls.isEmpty()) text("Quicksort: " +String.format("%.2f", frameRate) + 
  " frameRate / steps to finish: " + stackcalls.size() + " / sort by " + sortPixelMethod, 10, 18);
  else {
    println("pixels sorting complete");
    noLoop();
    save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
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
      //quickSort(lowerIndex, j);
      //instead of call recursively here, we will call during the draw loop
      stackcalls.add(new int[]{lowerIndex, j});
  }
  if (i < higherIndex) {
      //quickSort(i, higherIndex);
      //instead of call recursively here, we will call during the draw loop
      stackcalls.add(new int[]{i, higherIndex});
  }
}

void exchangePixel(int i, int j) {
  color temp = sorted.pixels[i];
  sorted.pixels[i] = sorted.pixels[j];
  sorted.pixels[j] = temp;
}
