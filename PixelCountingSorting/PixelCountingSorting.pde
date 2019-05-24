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

// Buckets: key is the hue colour 0~359 and the Queue are each pixels with that hue
HashMap<Integer, Queue<Integer>> counter;
int bucket = 0; // index for each counter bucket
int index = 0; // index of the pixel array
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

  // http://www.java67.com/2017/06/counting-sort-in-java-example.html 
  // Counting Sort function to sort arr[0...n-1]
  // create buckets; key is the hue colour 0~359 and the Queue are each pixels with that hue
  counter = new HashMap<Integer, Queue<Integer>>(hueColours);
  // fill buckets 
  for (int pix : sorted.pixels) {
    Queue<Integer> pixList = new LinkedList(); //to store same colour hue pixels
    int colour = Math.round(hue(pix));
    if (colour >= hueColours) colour=hueColours-1; //max must be hue=359
    if (counter.containsKey(colour)) pixList = counter.get(colour);
    pixList.add(pix);
    counter.put(colour, pixList);
  }
  index = img.pixels.length-1;
}

void draw() {
  //show frame rate and current gap/pixels size
  println("Counting sort: " +String.format("%.2f", frameRate) + "frameRate\t / steps: " + index);

  sorted.loadPixels();

  //just to have some time to show the img
  if (index == sorted.pixels.length-1) {
    delay(2000);
  }

  //multiStep during each loop for faster sort
  for (int n = 0; n < multiStep; n++) {

    // sort array 
    if (bucket < hueColours) {
      while (counter.containsKey(bucket) && !counter.get(bucket).isEmpty()) { 
        sorted.pixels[index--] = counter.get(bucket).remove();
      }
      bucket++;
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
    if (index > multiStep*2) {
      tint(255, 190);  // Apply transparency without changing color
      image(img, 0, 0.8* img.height, 0.2* img.width, 0.2* img.height);
      noTint();
    }
  }
  //Show framerate on display
  if (index > multiStep*2) {
    text("Counting sort: "+String.format("%.2f", frameRate) + 
      " frameRate / steps: " + index + " / sort by " + sortPixelMethod, 0, 18);
  }

  if (index < 1) {
    noLoop();
    save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
    println("pixels sorting complete");
  }
}
