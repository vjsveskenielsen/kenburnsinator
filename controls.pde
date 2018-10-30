void controlSetup() {
  cp5 = new ControlP5(this);
  int xoff = width-120, yoff = 20;
  int s_width = 100;
  int s_height = 20;

  cp5.addSlider("speed")
    .setPosition(xoff, yoff)
    .setSize(s_width, s_height)
    .setRange(.2, 3)
    .setValue(.2)
    .setLabel("speed")
    ;
    cp5.getController("speed").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    cp5.getController("speed").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  yoff += 50;
  cp5.addBang("random")
    .setPosition(xoff, yoff)
    .setSize(s_width, s_height)
    .setTriggerEvent(Bang.RELEASE)
    ;

  yoff += 50;
  cp5.addBang("loadImageFolder")
    .setPosition(xoff, yoff)
    .setSize(s_width, s_height)
    .setTriggerEvent(Bang.RELEASE)
    .setLabel("load image folder")
    ;

  yoff += 50;
  cp5.addTextfield("portValue")
    .setPosition(xoff, yoff)
    .setSize(s_width, s_height)
    .setAutoClear(false)
  ;
}

void speed(float value) {
  speed = value;
}

public void random() {
  animate(new PVector(random(0,1), random(0,1)));
}

public void loadImageFolder() {
  selectFolder("Select a folder to process:", "folderSelected");
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    loadImgs(selection);
  }
}

public void loadImgs(File dir) {
  List<File[]> imgPaths = new ArrayList<File[]>();
  imgPaths.add(dir.listFiles(PIC_FILTER));

  println("\nImage paths found for all folders:");

  int totalLength = 0;
  for (File[] paths : imgPaths) {
    totalLength += paths.length;
    println();
    printArray(paths);
  }

  println("Total images found in all subfolders:", totalLength);

  fill(200);
  noStroke();
  rect(0,0, width, 10);
  fill(255);
  int progress = 0;
  for (File[] paths : imgPaths)
    for (File f : paths) {
      imgs.add(loadImage(f.getPath()));
      rect(width/totalLength*progress,0, width/totalLength, 10);
    }
}

public void portValue(String theText) {

  char[] ints = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
  char[] input = theText.toCharArray();

  int check = 0;
  for (char ch : input) {
    for (char i : ints) {
      if (ch == i) check++;
    }
  }
  if (input.length == check && check < 6) port = Integer.parseInt(theText);
  updateOSC();
}
