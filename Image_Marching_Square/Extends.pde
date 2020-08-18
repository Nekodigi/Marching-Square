float brightAt(PImage img, int i, int j){//brightness at pixels
  return brightness(img.pixels[min(i, width-1)+min(j, height-1)*width])/bdiv;
}
