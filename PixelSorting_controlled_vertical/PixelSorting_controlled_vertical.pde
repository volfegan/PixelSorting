//based on https://www.openprocessing.org/sketch/700976

PImage img;
PImage sorted;
int cursorHistory_x = 0;
int cursorHistory_y = 0;
boolean saveFile = false;
int moveX = 0;
int moveY = 0;
boolean moveFoward = true;
boolean moveDown = true;
long startTime = 0;
String[] sort_dir = new String[] {"defaut", "↓", "~↓", "↑", "↑~", "↕", "~↕~", "static glitch"};


int multiStep = 5; //increase multistep for faster animation on autoloop
/* Direction on which the sorting moves:
 * 0: defaut
 * 1: ↓
 * 2: ↓ (more glitch)
 * 3: ↑
 * 4: ↑ (more glitch) [default]
 * 5: ↕
 * 6: ↕ (more glitch)
 * 7: glitch static effect */
int Sorting_direction = 0;
//automatic loop or mouse controlled: true or false
boolean mouseControl = false;
int updateLim = 5; //updateLim: 0~100 percentage of (line sorting updates)/frame (low = +framerate and glitch effect)
//select how to sort the pixels by "hue" or "brightness"
String sortPixelMethod = "hue";
//String sortPixelMethod = "brightness";


//save img by pressing space bar
public void keyPressed() {
  if (key == ' ') saveFile = true;
}

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
  size(width, height);
}

void setup() {
  //initial canvas size is set on settings
  textSize(18);
  colorMode(HSB, 360, 100, 100);
  //sorted image is the sorted img to be recreated on draw loop
  sorted = createImage(img.width, img.height, HSB);
  sorted = img.get();

  background(0);
  image(img, 0, 0);
}

/* Control the pixel sorting by mouse or by automatic control that imitate vertical and horizontal moviments
 * the X movement makes a pause when reaches any border 
 * @param boolean mouseControl control by mouse or auto
 */
void move_by(boolean mouseControl) {
  if (mouseControl == true) {
    moveX = mouseX;
    moveY = mouseY;
  } else {
    //multiStep just accelerate the walk
    for (int k=0; k < multiStep; k++) {
      //Check on boundaries when to reverse walk
      if (moveX >= img.width-1) moveFoward = false;
      if (moveX <= 0) moveFoward = true;
      if (moveY >= img.height-1) moveDown = false;
      if (moveY <= 0) moveDown = true;

      //change sorting method and direction of sort every finish pass
      if (moveY <= 0) {
        Sorting_direction = (Sorting_direction+1)%8;
        if (Sorting_direction%2 == 0) sortPixelMethod = "brightness";
        else sortPixelMethod = "hue";
        //sortPixelMethod = (random(0, 1) > 0.5) ? "brightness" : "hue"; // random choose how to sort
        moveY++; //it needs to move a pixel otherwise if the random increment on X doesn't occur this step will repeat
      }

      //increment walk on X
      if ((moveX < img.width-1 && moveX >= 0) && moveFoward) {

        moveX += (random(0, 1) > 0.2) ? 1 : 0;
        //
      } else  if (moveX > 0 && !moveFoward) {

        moveX -= (random(0, 1) > 0.2) ? 1 : 0;
      }
      //increment walk on Y
      if ((moveY < img.height-1 && moveY >= 0) && moveDown) {
        
        if (System.currentTimeMillis() > startTime + 2000 && moveY < img.height-1) moveY += (random(0, 1) > 0.5) ? 1 : 0;
        if (moveY == img.height-1) startTime = System.currentTimeMillis();
        
      } else if (moveY > 0 && !moveDown) {
        
        if (System.currentTimeMillis() > startTime + 2000) moveY -= (random(0, 1) > 0.7) ? 1 : 0;
        if (moveY == 0) startTime = System.currentTimeMillis();
      }
    }
  }
}

void draw() {
  //move by mouse or automatically
  move_by(mouseControl);

  //show frame rate and current sorting step
  println("Sorting horizontal lines ("+sort_dir[Sorting_direction]+"): " + 
    String.format("%.2f", ( ((float)moveY)/(img.height-1) )*100) + "% / " +
    String.format("%.2f", frameRate) + " frameRate"+" x="+moveX+" y="+moveY);
  
  sorted.loadPixels();

  //loop by each column
  for (int i=0; i<img.width; i++) {
    int[] column = new int[img.height];
    //get all the pixels from each column
    for (int h=0; h<img.height; h++) {
      color c = img.get(i, h);
      column[h] = c;
    }
    //do a sample sort only if moveX or moveY state changed
    if (random(0, 100) < updateLim && (cursorHistory_x != moveX || cursorHistory_y != moveY)) {
      int lowerIndex = 0;
      int higherIndex = moveY;

      switch(Sorting_direction) {
      case 1 :
        //sorting from top to bottom simple: [↓]
        lowerIndex = 0;
        higherIndex = moveY;
        break;
      case 2 :
        //sorting from top to bottom complex: [glitch ↓]
        lowerIndex = 0;
        if (random(0, 1) > 0.7 && moveY > column.length/3) {
          higherIndex = moveY + round(i*random(0, 1));
          if (higherIndex > column.length-1) higherIndex = column.length-1;
        }
        break;
      case 3 :
        //sorting from left to right simple: [↑]
        lowerIndex = column.length-1 - moveY;
        higherIndex = column.length-1;
        break;
      case 4 :
        //sorting from left to right complex: [↓ glitch]
        lowerIndex = column.length-1 - moveY;
        if (random(0, 1) > 0.7 && moveY > column.length/5) {
          lowerIndex = column.length-1 - moveY - round(i*random(0, 1));
          if (lowerIndex < 0) lowerIndex = 0;
        }
        higherIndex = column.length-1;
        break;
      case 5 :
        //sorting from middle streches outbounding [↕]
        lowerIndex = (column.length-1)/2 - moveY/2;
        higherIndex = (column.length-1)/2 + moveY/2;
        break;
      case 6 :
        //sorting from middle streches outbounding [glitch ↕]
        lowerIndex = (column.length-1)/2 - moveY/2;
        if (random(0, 1) > 0.7 && moveY > column.length/5) {
          lowerIndex = (column.length-1)/2 - moveY/2 - (round(i*random(0, 1)))/2;
          if (lowerIndex < 0) lowerIndex = 0;
        }
        higherIndex = (column.length-1)/2 + moveY/2;
        if (random(0, 1) > 0.7 && moveY > column.length/5) {
          higherIndex = (column.length-1)/2 + moveY/2 + (round(i*random(0, 1)))/2;
          if (higherIndex > column.length-1) higherIndex = column.length-1;
        }
        break;
      case 7 :
        //glitch static effect by choosing to sort random parts of lower and higher index
        lowerIndex = (int)((column.length-1 - moveY*random(0.5, 1))*random(0, 1));
        higherIndex = (int)((column.length-1)*random(0, 1));
        break;
      default:
        //sorting from left to right simple
        lowerIndex = column.length-1 - moveY;
        higherIndex = column.length-1;
        break;
      }
      
      quickSort(column, lowerIndex, higherIndex, sortPixelMethod);
      //put sorted pixels into the pixel array of the canvas
      for (int h=0; h<img.height; h++) {
        sorted.pixels[h*width+i] = column[h];  //The equivalent to set(i, h, #000000), but faster
      }
    }
  }

  sorted.updatePixels();
  image(sorted, 0, 0);

  //Show framerate on display
  if (saveFile == false) {
    text("Sorting vertical lines ("+sort_dir[Sorting_direction]+"): "
      + String.format("%.2f", ( ((float)moveY)/(img.height-1) )*100) + "% / "
      + String.format("%.2f", frameRate) + " frameRate / sort by " + sortPixelMethod, 0, 18);
  } else {
    //SAVE IMG
    save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
    saveFile = false;
  }

  cursorHistory_x = moveX;
  cursorHistory_y = moveY;
}

//http://www.java2novice.com/java-sorting-algorithms/quick-sort/
void quickSort(int[] array, int lowerIndex, int higherIndex, String sortPixelMethod) {
  float pivotPix = 0;
  int i = lowerIndex;
  int j = higherIndex;
  // calculate pivot number, I am taking pivot as middle index number
  int pivot = array[lowerIndex+(higherIndex-lowerIndex)/2]; //pixel values

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

      while (brightness(array[i]) > pivotPix) i++;
      while (brightness(array[j]) < pivotPix) j--;
    } else if (sortPixelMethod.equals("hue")) {

      while (hue(array[i]) > pivotPix) i++;
      while (hue(array[j]) < pivotPix) j--;
    }
    if (i <= j) {
      exchangePixel(array, i, j);
      //move index to next position on both sides
      i++;
      j--;
    }
  }
  // call quickSort() method recursively
  if (lowerIndex < j) {
    quickSort(array, lowerIndex, j, sortPixelMethod);
  }
  if (i < higherIndex) {
    quickSort(array, i, higherIndex, sortPixelMethod);
  }
}

void exchangePixel(int[] array, int i, int j) {
  color temp = array[i];
  array[i] = array[j];
  array[j] = temp;
}
