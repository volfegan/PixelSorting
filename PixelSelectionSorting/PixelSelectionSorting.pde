// modified version of Daniel Shiffman
// Code from: https://youtu.be/JUDYkxU6J0o

PImage img;
PImage sorted;
int index = 0;
int width = 0;
int height = 0;


boolean showBothIMGs = true; //to show both imgs side by side, only sorted img
//select how to sort the pixels by hue or brightness
String sortPixelMethod = "hue";
//String sortPixelMethod = "brightness";


//used to control speed of sorting process
int multiStep = 100;

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
}

void draw() {
  //show frame rate and current index/pixels size
  println("Selection sort: " +String.format("%.2f", frameRate) + "frameRate\t " 
    + index + "/" + sorted.pixels.length);

  sorted.loadPixels();

  //multiStep during each loop for faster sort
  for (int n = 0; n < multiStep; n++) {
    // Selection sort! very slow
    float record = -1;
    int selectedPixel = index;
    for (int j = index+1; j < sorted.pixels.length; j++) {
      color pix = sorted.pixels[j];

      //sort either by hue or brightness;
      float pixValue = 0;
      if (sortPixelMethod.equals("brightness")) pixValue = brightness(pix);
      else if (sortPixelMethod.equals("hue")) pixValue = hue(pix);

      if (pixValue > record) {
        selectedPixel = j;
        record = pixValue;
      }
    }

    // Swap selectedPixel with i
    color temp = sorted.pixels[index];
    sorted.pixels[index] = sorted.pixels[selectedPixel];
    sorted.pixels[selectedPixel] = temp;

    if (index < sorted.pixels.length -1) {
      index++;
    } else {
      noLoop();
      save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
      println("pixels sorting complete");
      break;
    }
  }

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
    if (index < sorted.pixels.length - multiStep) {
      tint(255, 190);  // Apply transparency without changing color
      image(img, 0, 0.8* img.height, 0.2* img.width, 0.2* img.height);
      noTint();
    }
  }
  //Show framerate on display
  if (index < sorted.pixels.length - multiStep) {
    text("Selection sort: " +String.format("%.2f", frameRate) + 
      " frameRate / steps: " + (sorted.pixels.length - index) + " / sort by " + sortPixelMethod, 0, 18);
  }
}
