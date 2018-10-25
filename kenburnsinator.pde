import de.looksgood.ani.*;
//import codeanticode.syphon.*;
import drop.*;
import controlP5.*;

ControlP5 cp5;

SDrop drop;
//SyphonServer server;

PVector pos = new PVector(0,0,1);
PVector tpos = new PVector(0,0,1);

PGraphics placeholder;
PImage output;
ArrayList<PImage> imgs = new ArrayList();
PGraphics c; //canvas
int cs_x, cs_y; //canvas scale; stores the scale to fit c into window

float speed;

void settings() {
  size(1024/2, 576/2, P3D);
}

void setup() {
  drop = new SDrop((Component)this.surface.getNative(), this);
  placeholder = createPlaceholder();
  c = createGraphics(1920, 1080);
  float sx = (float)width/(float)c.width;
  float sy = (float)height/(float)c.height;
  cs_x = round(sx*c.width);
  cs_y = round(sy*c.height);
  //server = new SyphonServer(this, "kenburnsinator");
  controlSetup();
  Ani.init(this);
  Ani.setDefaultEasing(Ani.LINEAR);
}

void draw() {
  background(0);
  c.beginDraw();
  c.background(255,0,0);
  c.imageMode(CENTER);
  if(imgs.size() > 0) output = imgs.get(imgs.size()-1);
  else output = placeholder;
  c.image(output,pos.x,pos.y, output.width*pos.z, output.height*pos.z);
  c.endDraw();
  image(c, 0,0,cs_x, cs_y);
  println(imgs.size());
}

void mousePressed() {
  animate(new PVector(mouseX, mouseY, random(1, 2)));
}

void animate(PVector in) {
  tpos.x = in.x;
  tpos.y = in.y;
  tpos.z = in.z;
  Ani.to(pos, speed, "x", tpos.x);
  Ani.to(pos, speed, "y", tpos.y);
  Ani.to(pos, speed, "z", tpos.z);
}

PGraphics createPlaceholder() {
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

void dropEvent(DropEvent theDropEvent) {
  println("");
  println("isFile()\t"+theDropEvent.isFile());
  println("isImage()\t"+theDropEvent.isImage());
  println("isURL()\t"+theDropEvent.isURL());

  if(theDropEvent.isImage()) {
    println("### loading image ...");
    PImage img = theDropEvent.loadImage();
    imgs.add(img);
  }
}
