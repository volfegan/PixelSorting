 //http://www.java2novice.com/java-sorting-algorithms/merge-sort/class MyMergeSort {

public class PixelMergeSort {
  
  private int[] array;
  private int[] tempMergArr;
  private int length;
  private String sortPixel;
  
  public PixelMergeSort(int inputArr[], String sortPixelMethod) {
      this.array = inputArr;
      this.length = inputArr.length;
      this.tempMergArr = new int[length];
      this.sortPixel = sortPixelMethod;
      mergeSort(0, length - 1);
  }
  private void mergeSort(int lowerIndex, int higherIndex) {
       
      if (lowerIndex < higherIndex) {
          int middle = lowerIndex + (higherIndex - lowerIndex) / 2;
          // Below step sorts the left side of the array
          mergeSort(lowerIndex, middle);
          // Below step sorts the right side of the array
          mergeSort(middle + 1, higherIndex);
          // Now merge both sides
          mergeParts(lowerIndex, middle, higherIndex);
      }
  }
   
  private void mergeParts(int lowerIndex, int middle, int higherIndex) {
    
    tempMergArr = sorted.pixels.clone();
    int i = lowerIndex;
    int j = middle + 1;
    int k = lowerIndex;
    while (i <= middle && j <= higherIndex) {
        if (sortPixel.equals("hue") && hue(tempMergArr[i]) >= hue(tempMergArr[j])) {
            array[k] = tempMergArr[i];
            i++;
        } else if (sortPixel.equals("brightness") && brightness(tempMergArr[i]) >= brightness(tempMergArr[j])) {
            array[k] = tempMergArr[i];
            i++;
        } else {
            array[k] = tempMergArr[j];
            j++;
        }
        k++;
    }
    while (i <= middle) {
        array[k] = tempMergArr[i];
        k++;
        i++;
    }
   
  }
}
