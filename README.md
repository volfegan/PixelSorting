Pixel Sorting
============

A set of pixel sorting visualization using different methods on Processing.
This is my attempt to learn those sorting algorithm, but with something aesthetically pleasing. Those sketches with "Simple" on its name are the 1st attempt to understand the pixel sorting process and don't have or have limited visualization.
Since we are talking about sorting pixels, there are lots of ways in doing that:
- you can sort by hue, brightness, by the colour channel, saturation (HSB colour mode). So far I only did for hue and brightness.
- you can sort just like above and with any sorting method, but instead of sorting all the pixels of the images, sort line by line separated, either horizontally or vertically or a combination of those. This is the simpler version, sorted the whole pixels.

\- \- \-

#### Basic setup and config
Most of the processing sketches have the following variables to control the visualization and sorting.

* boolean showBothIMG -> can be either "true" or "false"; If true, it shows both imgs side by side, otherwise it only shows the sorted img with the original image in the corner reduced to 20% the size. If the image is bigger than the device's screen, it will rescale the image to 80% of the screen.
* String sortPixelMethod -> can be either "hue" or "brightness". As the name sugests the user can select how to sort the pixels by hue or brightness
* int multiStep -> each sorter has its own value. This is used to control speed of sorting process. For each frame, the process will run a  multiStep times.

\- \- \-

Bellow there are the links of video examples for each visualizations method (GIF images were too big to put here). It also mentions if that sorting method is stable or not. Stable sort algorithms sort repeated elements in the same order that they appear in the input. We can actually see the differences between a stable sorting and an unstable just by see the pixels arrangement. This is evident on the images on the bottom of the page.

|  *Simple sort* |
|     :---:      |

#### Pixel Bubble Sorting
Stable: Yes

[![Pixel Bubble Sorting on cat](https://i.ytimg.com/vi/Y_8RPyw9KmI/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLClN4KYSYodKXY6YPRF502U9Z7fWQ)](https://www.youtube.com/watch?v=Y_8RPyw9KmI&t=5s)

#### Pixel Insertion Sorting
Stable: Yes

[![Pixel Insertion Sorting on cat](https://i.ytimg.com/vi/pMNCh34BpSo/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLCWGV1H0d28x_LkvIgCbbeJQPDQvw)](https://www.youtube.com/watch?v=pMNCh34BpSo&t=10s)

#### Pixel Selection Sorting
Stable: No

[![Pixel Selection Sorting on cat](https://i.ytimg.com/vi/doq81d76aFM/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLBEGzfjyR3DPRWhpqFtL2y_1JG1sg)](https://www.youtube.com/watch?v=doq81d76aFM)

| *Efficient sort* |
|      :---:       |

#### Pixel Shell Sorting
Stable: No

[![Pixel Shell Sorting on cat](https://i.ytimg.com/vi/71CXFdwgP7Q/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLDmuiwd2Y0rRxFQ5pOyDibb5QfBgQ)](https://www.youtube.com/watch?v=71CXFdwgP7Q)

#### Pixel Quick Sorting
Stable: No (I know there are stable versions, but not this one)

[![Pixel Quick Sorting on cat](https://i.ytimg.com/vi/ay6lKu8uFjY/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLDaGiJGYeXieb_LFIbecka2v-LYdw)](https://www.youtube.com/watch?v=ay6lKu8uFjY)

#### Pixel Merge Sorting
Stable: Yes

[![Pixel Merge Sorting on cat](https://i.ytimg.com/vi/uOUg2ii-448/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLCmn1pQOLlMUxdLcYtYHuXHN11tdg)](https://www.youtube.com/watch?v=uOUg2ii-448)

#### Pixel Heap Sorting
Stable: No

[![Pixel Heap Sorting on cat](https://i.ytimg.com/vi/Vb2jU7L__Ho/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLArpqIYRhPqXsNrBKA8VScBA_1grw)](https://www.youtube.com/watch?v=Vb2jU7L__Ho)

#### Pixel Counting Sorting
Stable: Yes

[![Pixel Counting Sorting on cat](https://i.ytimg.com/vi/6Qgppldl4F8/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLBbsIWuHTrAWHb-f6HttK_A6Yf1lA)](https://www.youtube.com/watch?v=6Qgppldl4F8)

#### Pixel Radix LSD (least significant digit) Sorting
Stable: Yes

[![Pixel Radix LSD (least significant digit) Sorting on cat](https://i.ytimg.com/vi/InzY4zrw5Jg/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLCc_9tlkxToRrfpse3Oc5QCbWUoOg)](https://www.youtube.com/watch?v=InzY4zrw5Jg)

\- \- \-

\[ Visualizing a stable sort against an unstable \]

If you check the pixels sorted by a stable algorithm for the same image, they will be the same. The same image sorted by an unstable algorithm will result in different configurations. Check below the sunflower image sorted by brightness using the insertion and merge methods. They are the same:

![sunflower](PixelMergeSortingSimple/data/sunflower400.jpg)
![sunflower Pixels Sorted By brightness](PixelMergeSortingSimple/sunflower400_PixelsSortedBy_brightness.jpg)

Now compare the same image sorted respectively by quicksort and shellsort:

![sunflower Pixels Sorted By brightness quicksort](PixelQuickSortingSimple/sunflower400_PixelsSortedBy_brightness.jpg)
![sunflower Pixels Sorted By brightness shellsort](PixelShellSortingSimple/sunflower400_PixelsSortedBy_brightness.jpg)

You can see that the image from quicksort and shellsort are different from the stable sorters and also different from each other.

                   __________________________
                  /                           \
                 |I hope this was interesting. |
                 \__   __ __ __ __ __ __ __ __/
                    | /
             __w    |/
     (\{\  ,%%%%            .-.   __
     { { \.%%%_/   ,_*   _ /   \ /  \
     { {  \%%/(___//    / \|   |/   |
     { {\,%%%|[))-'    :   \   /  _/_
     {/{/\,%%)\(       _\_  \_|_.'   '.
           '%]\\      :   '-(  )_____.'
             ((']       '.__/'--\   \
              \yI\         /  |  \   )
             (/  (\       /   /  |'-:
             7    k\      '--'\__/ \ \
            J'    `L_               \ \
                                     \ \
\- \- \-

\[ all code available under MIT License - feel free to use. \]
