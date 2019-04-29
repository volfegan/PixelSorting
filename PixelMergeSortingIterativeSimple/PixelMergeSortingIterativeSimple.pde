PImage img;
PImage sorted;
boolean started = false;
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
    mergeSort(sorted.pixels, sortPixelMethod);
  }

  //show sorted pixels img
  sorted.updatePixels();
  background(0);
  image(sorted, 0, 0);

  if (started) {
    noLoop();
    save(filename+"_PixelsSortedBy_"+sortPixelMethod+".jpg");
    println("pixels sorting complete in "+(System.currentTimeMillis() - startTime)+" milisecs / sort by " + sortPixelMethod);
  }
}
/* Iterative mergesort function to sort arr[0...n-1]
 https://www.geeksforgeeks.org/iterative-merge-sort/
 */
void mergeSort(int arr[], String sortPixelMethod) { 
  if (arr.length < 2) {
    //Array already sorted
    return;
  }
  int division = 1; //The size of the sub-arrays. Constantly changing from 1 to n/2 

  // startL - start index for left sub-array
  // stopR - end index for the right sub-array
  int startL, mid, stopR;

  // Merge subarrays in bottom up manner. First merge subarrays  
  // of size 1 to create sorted subarrays of size 2, then merge 
  // subarrays of size 2 to create sorted subarrays of size 4, continue... 
  while (division < arr.length-1) {
    // Pick starting point of different subarrays of current size 
    startL = 0;
    while (startL <= arr.length-1) {

      stopR = Math.min(startL + 2*division - 1, arr.length-1);
      mid = startL + division -1;
      if (mid > arr.length-1)
        mid = (stopR + startL)/2;

      //System.out.printf("startL=%d, mid=%d, stopR=%d\n", startL, mid, stopR);

      // Create 2x Subarrays arr[startL...mid] & arr[mid+1...stopR]
      // sort and merge them
      merge(arr, startL, mid, stopR, sortPixelMethod);

      startL += 2*division;
    }
    division *= 2;
  }
}

/* Function to merge the two halves arr[l..m] and arr[m+1..r] of array arr[] */
void merge(int arr[], int l, int m, int r, String sortPixelMethod) { 
  int i, j, k; 
  int n1 = m - l + 1; //L[] temp arrays size
  int n2 = r - m;  //R[] temp arrays size

  /* create temp arrays */
  int L[] = new int[n1]; 
  int R[] = new int[n2]; 

  /* Copy data to temp arrays L[] 
   and R[] */
  for (i = 0; i < n1; i++) 
    L[i] = arr[l + i]; 
  for (j = 0; j < n2; j++) 
    R[j] = arr[m + 1 + j]; 

  /* Merge the temp arrays back into arr[l..r]*/
  i = 0; 
  j = 0; 
  k = l; 
  while (i < n1 && j < n2) { 
    if (
      (sortPixelMethod.equals("hue") && hue(L[i]) >= hue(R[j]))
      ||
      (sortPixelMethod.equals("brightness") && brightness(L[i]) >= brightness(R[j]))
      ) { 
      arr[k] = L[i]; 
      i++;
    } else { 
      arr[k] = R[j]; 
      j++;
    } 
    k++;
  } 

  /* Copy the remaining elements of L[], if there are any */
  while (i < n1) { 
    arr[k] = L[i]; 
    i++; 
    k++;
  } 

  /* Copy the remaining elements of R[], if there are any */
  while (j < n2) { 
    arr[k] = R[j]; 
    j++; 
    k++;
  }
}
