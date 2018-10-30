import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.List; 
import java.io.FileFilter; 
import java.io.FilenameFilter; 
import de.looksgood.ani.*; 
import codeanticode.syphon.*; 
import controlP5.*; 
import oscP5.*; 
import netP5.*; 
import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class kenburnsinator extends PApplet {













OscP5 oscP5;
Server localServer;
String ipAdress;
int port = 9999;

ControlP5 cp5;
float speed = .2f;

SyphonServer server;

PVector pos = new PVector(0,0);
PVector tpos = new PVector(0,0);

PGraphics placeholder;
PImage output;
ArrayList<PImage> imgs = new ArrayList();
PGraphics c; //canvas
int cs_x, cs_y; //canvas scale; stores the scale to fit c into window

final FilenameFilter PIC_FILTER = new FilenameFilter() {
  final String[] exts = {
    ".png", ".jpg", ".jpeg", ".gif"
  };

  public @Override boolean accept(final File path, String name) {
    name = name.toLowerCase();
    for (final String ext : exts)  if (name.endsWith(ext))  return true;
    return false;
  }
};

public void settings() {
  size(1024/2, 576/2, P3D);
}

public void setup() {
  placeholder = createPlaceholder();
  c = createGraphics(1920, 1080, P3D);
  c.imageMode(CENTER);
  float sx = (float)width/(float)c.width;
  float sy = (float)height/(float)c.height;
  cs_x = round(sx*c.width);
  cs_y = round(sy*c.height);
  server = new SyphonServer(this, "kenburnsinator");

  controlSetup();
  updateOSC();
  Ani.init(this);
  Ani.setDefaultEasing(Ani.LINEAR);

}

public void draw() {
  background(0);
  c.beginDraw();
  c.background(255,0,0);
  if(imgs.size() > 0) output = imgs.get(imgs.size()-1);
  else output = placeholder;

  float s_x, s_y;
  if (pos.x < .5f) s_x = 1.f-pos.x;
  else s_x = pos.x;
  if (pos.y < .5f) s_y = 1.f-pos.y;
  else s_y = pos.y;

  c.image(output,pos.x*c.width,pos.y*c.height, s_x*2.f*output.width, s_x*2.f*output.height);
  c.endDraw();
  image(c, 0+20,0+20,cs_x-40, cs_y-40);
  server.sendImage(c);

  fill(0, 200);
  noStroke();
  rect(width-140, 0, 120, height);

}

public void animate(PVector in) {
  tpos.x = in.x;
  tpos.y = in.y;
  Ani.to(pos, speed, "x", tpos.x);
  Ani.to(pos, speed, "y", tpos.y);
}

public PGraphics createPlaceholder() {
  PGraphics p = createGraphics(1920, 1080);
  p.beginDraw();
  p.fill(230);
  p.stroke(255);
  p.strokeWeight(5);
  p.rect(0,0,p.width, p.height);
  p.line(0,0, p.width, p.height);
  p.line(p.width, 0, 0, p.height);
  p.endDraw();
  return p;
}

public void oscEvent(OscMessage theOscMessage) {
  String str_in[] = split(theOscMessage.addrPattern(), '/');
  println(str_in);
  if (str_in[1].equals("kenburnsinator")) {

    if (str_in[2].equals("random")) {
      random();
    } else if (str_in[2].equals("speed") && theOscMessage.checkTypetag("f")) {
      float value = theOscMessage.get(0).floatValue();
      float max = cp5.getController("speed").getMax();
      cp5.getController("speed").setValue(value*max);
    }

  }
}

public void updateOSC() {
  ipAdress = Server.ip();
  oscP5 = new OscP5(this, port);
  cp5.getController("portValue").setLabel("port: " + port);
}
public void controlSetup() {
  cp5 = new ControlP5(this);
  int xoff = width-120, yoff = 20;
  int s_width = 100;
  int s_height = 20;

  cp5.addSlider("speed")
    .setPosition(xoff, yoff)
    .setSize(s_width, s_height)
    .setRange(.2f, 3)
    .setValue(.2f)
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

public void speed(float value) {
  speed = value;
}

public void random() {
  animate(new PVector(random(0,1), random(0,1)));
}

public void loadImageFolder() {
  selectFolder("Select a folder to process:", "folderSelected");
}

public void folderSelected(File selection) {
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "kenburnsinator" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
