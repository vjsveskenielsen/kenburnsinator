/* STATIC FILE IMPORT
import java.util.List;
import java.io.FileFilter;
import java.io.FilenameFilter;
*/
import de.looksgood.ani.*;
import drop.*;

SDrop drop;

/* STATIC FILE IMPORT
final FileFilter FOLDER_FILTER = new FileFilter() {
  @ Override boolean accept(final File path) {
    return path.isDirectory();
  }
};

final FilenameFilter PIC_FILTER = new FilenameFilter() {
  final String[] exts = {
    ".png", ".jpg", ".jpeg", ".gif"
  };

  @ Override boolean accept(final File path, String name) {
    name = name.toLowerCase();
    for (final String ext : exts)  if (name.endsWith(ext))  return true;
    return false;
  }
};
*/
PVector pos = new PVector(0,0);
PVector tpos = new PVector(0,0);

PGraphics placeholder;
PImage output;
ArrayList<PImage> imgs = new ArrayList();

void settings() {
  size(400, 400);
}

void setup() {
  /* STATIC FILE IMPORT
  initImgs(); //load all available images into imgs
  */
  drop = new SDrop(this);
  placeholder = createPlaceholder();

  Ani.init(this);
  Ani.setDefaultEasing(Ani.LINEAR);
}

void draw() {
  background(0);
  imageMode(CENTER);

  if(imgs.size() > 0) output = imgs.get(imgs.size()-1);
  else output = placeholder;
  image(output,pos.x,pos.y);
}

/* STATIC FILE IMPORT
void initImgs() {
  File dataFolder = dataFile("");

  File[] imgDirs = dataFolder.listFiles(FOLDER_FILTER);
  imgDirs = (File[]) append(imgDirs, dataFolder);

  println(imgDirs.length, "folders found:");
  printArray(imgDirs);

  List<File[]> imgPaths = new ArrayList<File[]>();

  for (File dir : imgDirs)
    imgPaths.add(dir.listFiles(PIC_FILTER));

  println("\nImage paths found for all folders:");

  int totalLength = 0;
  for (File[] paths : imgPaths) {
    totalLength += paths.length;
    println();
    printArray(paths);
  }

  println("Total images found in all subfolders:", totalLength);

  imgs = new PImage[totalLength];
  int idx = 0;
  for (File[] paths : imgPaths)
    for (File f : paths)
      imgs[idx++] = loadImage(f.getPath());
}
*/

void mousePressed() {
  tpos.x = mouseX;
  tpos.y = mouseY;
  Ani.to(pos, 3.0f, "x", tpos.x);
  Ani.to(pos, 3.0f, "y", tpos.y);
}

PGraphics createPlaceholder() {
  PGraphics p = createGraphics(1920, 1080);
  p.beginDraw();
  p.fill(0);
  p.stroke(255);
  p.strokeWeight(5);
  p.rect(0,0,width, height);
  p.line(0,0, p.width, p.height);
  p.line(p.width, 0, 0, p.height);
  p.endDraw();
  return p;
}

void dropEvent(DropEvent theDropEvent) {
  println("");
  println("isFile()\t"+theDropEvent.isFile());
  println("isImage()\t"+theDropEvent.isImage());
  println("isURL()\t"+theDropEvent.isURL());

  // if the dropped object is an image, then
  // load the image into our PImage.
  if(theDropEvent.isImage()) {
    println("### loading image ...");
    PImage img = theDropEvent.loadImage();
    imgs.add(img);
  }
}
