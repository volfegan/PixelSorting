import java.util.Queue;
import java.util.LinkedList;
import java.util.Map;

PImage img;
PImage sorted;
boolean started = false;
int width = 0;
int height = 0;

long startTime = 0; //measure the speed of sorting process


//Counting sort can only sort integers so only colour hue is available
//pixels brightness gives an float number and at the moment I not really into
//finding a brightness or luminance equation that spillls integers only
String sortPixelMethod = "hue";
int hueColours = 360;


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
  colorMode(HSB, hueColours, 100, 100);
  sorted = createImage(img.width, img.height, HSB);
  sorted = img.get();
  background(0);
  image(sorted, 0, 0);

  startTime = System.currentTimeMillis();
}

void draw() {

  sorted.loadPixels();

  if (started == false) {
    started = true;
    radixLSDsort(sorted.pixels);
  }

  //show sorted pixels img
  sorted.updatePixels();
  background(0);
  image(sorted, 0, 0);

  if (started) {
    noLoop();
    save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
    println("pixels sorting complete in "+(System.currentTimeMillis() - startTime)+
      " milisecs / sort by " + sortPixelMethod);
  }
}

/* https://en.wikipedia.org/wiki/Radix_sort#Implementation_in_java
 * https://www.growingwiththeweb.com/sorting/radix-sort-lsd/
 * 
 * LSD (least significant digit) Radix Sort function to sort arr[0...n-1]
 * Radix used is base 10
 * @param int[] arr to be of sorted
 */
public void radixLSDsort(int[] arr) {

  // Find the maximum hue Colour pixel from the img
  int maxHue = 0;
  for (int pix : arr) {
    if (maxHue < hue(pix))
      maxHue = Math.round(hue(pix));
  }
  // Do counting sort for every digit for the select digit position given by exp (10^i)
  for (int exp = 1; maxHue/exp > 0; exp *= 10) 
    countingSortByDigit(arr, exp);
}

/*
 * Counting Sort according to the digit exp (10^i).
 *
 * @param int[] arr to be of sorted
 * @param int exp order of digit to sort (10^i)
 */
public void countingSortByDigit(int[] arr, int exp) {
  int radix = 10; //using base 10
  // Initialize buckets; 
  //key is the radix base number [0~9] and the Queue are pixels with hue value for the selected exp digit
  HashMap<Integer, Queue<Integer>> counter = new HashMap<Integer, Queue<Integer>>(radix);

  // fill buckets by counting of occurrences of pixels with same exp digit
  for (int pix : arr) {
    Queue<Integer> pixList = new LinkedList(); //to store same exp digit pixels
    int colour = Math.round(hue(pix));
    if (colour > 359) colour=359; //max must be hue=359

    int  bucket = (int)((colour / exp) % radix); // index for each counter [0~9]
    //println("hue(pix)="+colour+"; bucket="+bucket);
    if (counter.containsKey(bucket)) pixList = counter.get(bucket);
    pixList.add(pix);
    counter.put(bucket, pixList);
  }
  // sort array
  int ndx = 0; 
  for (int bucket = radix-1; bucket >= 0; bucket--) { 
    while (counter.containsKey(bucket) && !counter.get(bucket).isEmpty()) { 
      arr[ndx++] = counter.get(bucket).remove();
    }
  }
}
