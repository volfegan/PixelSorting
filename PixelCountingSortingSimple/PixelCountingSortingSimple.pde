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
    countingSort(sorted.pixels, hueColours);
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

/* http://www.java67.com/2017/06/counting-sort-in-java-example.html 
 * Counting Sort function to sort arr[0...n-1]
 *
 * @param int[] arr to be of sorted
 * @param int k size of the bucket (for hue its 360 colours)
 */
public void countingSort(int[] arr, int k) { 
  // create buckets; key is the hue colour 0~359 and the Queue are each pixels with that hue
  HashMap<Integer, Queue<Integer>> counter = new HashMap<Integer, Queue<Integer>>(k);

  // fill buckets 
  for (int pix : arr) {
    Queue<Integer> pixList = new LinkedList(); //to store same colour hue pixels
    //println("hue(pix)="+hue(pix)+"; brightness(pix)="+brightness(pix));
    int colour = Math.round(hue(pix));
    if (colour >= k) colour=k-1; //max must be hue=359
    if (counter.containsKey(colour)) pixList = counter.get(colour);
    pixList.add(pix);
    counter.put(Math.round(hue(pix)),pixList);
  }
  // sort array 
  int ndx = arr.length-1; 
  for (int i = 0; i < k; i++) { 
    while (counter.containsKey(i) && !counter.get(i).isEmpty()) { 
      arr[ndx--] = counter.get(i).remove();
    }
  }
} 
