import java.util.Queue;
import java.util.LinkedList;
import java.util.Map;

PImage img;
PImage sorted;
int width = 0;
int height = 0;


boolean showBothIMGs = false; //to show both imgs side by side, only sorted img
//Counting sort can only sort integers so only colour hue is available
//pixels brightness gives an float number and at the moment I not really into
//finding a brightness or luminance equation that spillls integers only
String sortPixelMethod = "hue";


//used to control speed of sorting process
int multiStep = 1;

// Buckets: is the radix base number [0~9] and the Queue are pixels with hue value for the selected exp digit
HashMap<Integer, Queue<Integer>> counter;
int radix = 10; //using base 10 and not any other radix system
int bucket = 0; // index for each counter [0~9]
int index = 0; // index of the pixel array
int exp = 1; //exp is 10^i to sort by the digits, starting by the least significant
int hueColours = 360;
int maxHue = 0; //maximum hue Colour pixel from the img
boolean countingSortStared = false;

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

void settings() {
  selectInput("Select an image file to process:", "fileSelected");
  interrupt(); //interrupt process until img is selected

  //for testing
  //img = loadImage("sunflower400.jpg");
  width = img.width;
  //width = img.width * 2; If want to show both original and sorted pics
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
  textSize(18);
  colorMode(HSB, hueColours, 100, 100);
  sorted = createImage(img.width, img.height, HSB);
  sorted = img.get();

  //show original and sorted imgs
  background(0);
  if (showBothIMGs && 2 * img.width < displayWidth) {
    image(img, 0, 0);
    image(sorted, img.width, 0);
  } else {
    image(sorted, 0, 0);
  }

  // https://en.wikipedia.org/wiki/Radix_sort#Implementation_in_java
  // https://www.growingwiththeweb.com/sorting/radix-sort-lsd/
  // LSD (least significant digit) Radix Sort
  // Radix used is base 10
  // Find the maximum hue Colour pixel
  for (int pix : sorted.pixels) {
    if (maxHue < hue(pix))
      maxHue = Math.round(hue(pix));
  }
}

void draw() {
  //show frame rate and current gap/pixels size
  println("Counting sort: " +String.format("%.2f", frameRate) + "frameRate\t / steps: " + index +
    " / sorting digit: k*" + exp);

  sorted.loadPixels();

  //just to have some time to show the img
  if (index == 0 && exp == 1) {
    delay(2000);
  }

  //multiStep during each loop for faster sort
  for (int n = 0; n < multiStep; n++) {

    // Do counting sort for every digit for the select digit position given by exp (10^i)
    if (maxHue/exp > 0) {

      if (index == 0 && !countingSortStared) {
        counter = new HashMap<Integer, Queue<Integer>>(radix);
        // fill buckets by counting of occurrences of pixels with same exp digit
        for (int pix : sorted.pixels) {
          Queue<Integer> pixList = new LinkedList(); //to store same exp digit pixels
          int colour = Math.round(hue(pix));
          if (colour >= hueColours) colour=hueColours-1; //max must be hue=359

          bucket = (int)((colour / exp) % radix);
          if (counter.containsKey(bucket)) pixList = counter.get(bucket);
          pixList.add(pix);
          counter.put(bucket, pixList);
        }
        bucket = radix-1;
        countingSortStared = true;
      }

      // sort array 
      if (bucket >= 0) {
        while (counter.containsKey(bucket) && !counter.get(bucket).isEmpty()) { 
          sorted.pixels[index++] = counter.get(bucket).remove();
        }
        if (bucket > 0)
          bucket--;
      }
    }
    if (index == sorted.pixels.length) {
      exp *= 10;
      index = 0;
      countingSortStared = false;
    }
  }
  //show sorted pixels img so far
  sorted.updatePixels();
  //show original and sorted imgs
  background(0);
  if (showBothIMGs && 2 * img.width < displayWidth) {
    image(img, 0, 0);
    image(sorted, img.width, 0);
  } else {
    image(sorted, 0, 0);
    if (maxHue/exp > 0) {
      tint(255, 190);  // Apply transparency without changing color
      image(img, 0, 0.8* img.height, 0.2* img.width, 0.2* img.height);
      noTint();
    }
  }
  //Show framerate on display
  if (maxHue/exp > 0) {
    text("Counting sort: "+String.format("%.2f", frameRate) + 
      " frameRate / steps: " + index + " / sort by " + sortPixelMethod, 0, 18);
  }

  if (maxHue/exp == 0) {
    noLoop();
    save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
    println("pixels sorting complete");
  }
}
