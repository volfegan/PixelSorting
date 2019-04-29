import java.util.Queue;
import java.util.LinkedList;

PImage img;
PImage sorted;
int gap = 0;
int width = 0;
int height = 0;


boolean showBothIMGs = false; //to show both imgs side by side, only sorted img
//select how to sort the pixels by hue or brightness
String sortPixelMethod = "hue";
//String sortPixelMethod = "brightness";


//used to control speed of sorting process
int multiStep = 1;

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
  sorted = createImage(img.width, img.height, HSB);
  sorted = img.get();

  //show original and sorted imgs
  background(0);
  if (showBothIMGs && 2 * img.width < displayWidth) {
    image(img, 0, 0);
    image(sorted, img.width, 0);
  } else {
    image(sorted, 0, 0);
    if (gap > 1) {
      tint(255, 190);  // Apply transparency without changing color
      image(img, 0, 0.8* img.height, 0.2* img.width, 0.2* img.height);
      noTint();
    }
  }

  gap = sorted.pixels.length/2; //replaced on draw() --> for (int gap = arrayLength / 2; gap > 0; gap /= 2)
}

void draw() {
  //show frame rate and current gap/pixels size
  println(String.format("%.2f", frameRate) + "frameRate\t gap: " 
    + gap);

  sorted.loadPixels();

  //just to have some time to show the img
  if (gap == sorted.pixels.length/2) {
    delay(2000);
  }


  // Shell sort!
  //https://www.code2bits.com/shell-sort-algorithm-in-java/
  if (gap > 0) { //replaced --> for (int gap = arrayLength / 2; gap > 0; gap /= 2)

    for (int i = gap; i < sorted.pixels.length; i++) {
      color temp_pix = sorted.pixels[i];
      float tempValue = 0;

      int j = i;

      //sort either by hue or brightness;
      if (sortPixelMethod.equals("brightness")) {
        tempValue = brightness(temp_pix);

        while (j >= gap && brightness(sorted.pixels[j - gap]) < tempValue) {
          sorted.pixels[j] = sorted.pixels[j - gap];
          j -= gap;
        }
      } else if (sortPixelMethod.equals("hue")) {
        tempValue = hue(temp_pix);

        while (j >= gap && hue(sorted.pixels[j - gap]) < tempValue) {
          sorted.pixels[j] = sorted.pixels[j - gap];
          j -= gap;
        }
      }
      sorted.pixels[j] = temp_pix;
    }
    gap /= 2; //replaced --> for (int gap = arrayLength / 2; gap > 0; gap /= 2)
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
    if (gap > 1) {
      tint(255, 130);  // Apply transparency without changing color
      image(img, 0, 0.8* img.height, 0.2* img.width, 0.2* img.height);
      noTint();
    }
  }
  //Show framerate on display
  if (gap > 1) {
    text(String.format("%.2f", frameRate) + 
      " frameRate / gap: " + gap + " / sort by " + sortPixelMethod, 0, 18);
  } else {
    noLoop();
    save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
    println("pixels sorting complete");
  }
}
