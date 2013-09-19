import controlP5.*;
ControlP5 cp5; 
ArrayList<aState> states=new ArrayList<aState>();
aState totals;
aState tempState;
String [] temp;
float[] temp2;
int doubleH;
color[] top=new color[6];
int screenWidth=1200;
int screenHeight=800;
float maxValueFor;
float circleX=100;
boolean drawTip=false;
float mouseOverValue=0;
DropdownList droplist;
DropdownList droplistoption;
//int style=2;
void setup() {
  size(screenWidth, screenHeight);
  cp5 = new ControlP5(this);
  String lines[] = loadStrings("CommuterData.csv");
  //String [][] csv;
  //int csvWidth=0;
  doubleH=-1;
  //false means absolute, true means percentile

  for(int i=0;i<top.length;i++)top[i]=color(random(255),random(255),random(255));
  /*
  for (int i=0; i < lines.length; i++) {
    String [] chars=split(lines[i],',');
    if (chars.length>csvWidth){
      csvWidth=chars.length;
    }
  }

  csv = new String [lines.length][csvWidth];

  //parse values into 2d array
  for (int i=0; i < lines.length; i++) {
    String [] temp = new String [lines.length];
    temp= split(lines[i], ',');
    for (int j=0; j < temp.length; j++){
      csv[i][j]=temp[j];
    }
  }
  */
  for (int i=2; i < lines.length; i++) {
    temp= new String [lines.length];
    temp2=new float[8];
    temp= split(lines[i], ',');
    for (int j=1; j < temp.length; j++){
      temp2[j-1]=Float.parseFloat(temp[j]);
    }
    states.add(new aState(temp[0],temp2));
  }
  temp= split(lines[1], ',');
  for (int j=1; j < temp.length; j++){//instantiates the totals
    temp2[j-1]=Float.parseFloat(temp[j]);
  }
  totals=new aState(temp[0],temp2);
  //test
  //println(csv[0]);
  //println(csv[2][2]);
  //println(csv[0][0]);
  // add a dropdownlist at position (100,100)
  
  droplist = cp5.addDropdownList("Alabama").setPosition(658, 50);
  droplistoption = cp5.addDropdownList("Total Values").setPosition(689,442);
  droplistoption.addItem("Total Values",1);
  droplistoption.addItem("Percentage",2);
  

  // add items to the dropdownlist
  int counter=0;
  for (aState s:states) {
    droplist.addItem(s.name, counter);
    s.c=color(random(255),random(255),random(255));
    s.c=lerpColor(s.c,color(255,255,255),.5);
    counter++;
  }
  
  //println(topThree(1));
}

void draw() {
  background(128);
  doubleH=-1;
  fill(0);
  textSize(22);
  text("CS 4460 HW 5",553,29);
  textSize(12);
  fill(top[0]);
  if(dist(mouseX,mouseY,1100,circleX)<40)circleX=mouseY;
  if(circleX<100)circleX=100;
  if(circleX>700)circleX=700;
  println(mouseX+" "+mouseY);
  rect(1100-10,circleX-10,20,20,6);
  noFill();
  stroke(0);
  drawTip=false;
  mouseOverValue=0;
  color tipText=color(0,0,0);
  String[] str={"Drove Alone","Car Pooled","Public Trans","Walk","Other","Home"};
  rect(800,200,200,220,6);
  for(int i=0;i<top.length;i++)
  {
    fill(0);
    text(str[i],850,240+i*32);
    text(str[i],220+i*145,780);
    fill(top[i]);
    rect(820,220+i*32,24,24);
    
  }
  fill(0);
  text("Top three in each catagory by ",513,440);
  text("By section breakdown of ",513,49);
  if(droplistoption.getValue()==2)//1 means pie chart, 2 means bar graph
  {
    maxValueFor=map((700-circleX),0,600,0,100);
    text("max value for top three: "+maxValueFor+"%",980,80);
  }
  else
  {
    maxValueFor=map((700-circleX),0,600,0,11503748);
    text("max value for top three: "+maxValueFor,940,80);
    
  }
  line(1100,100,1100,700);
  //line();
  //line()
  
  tempState=states.get(int(droplist.getValue()));//tempState is now the currently selected state in dropdown
  //println(tempState.name);
  //print(droplist.getValue());
  float[] sixValues=tempState.getSixValues();
  if(droplistoption.getValue()==2)//1 means pie chart, 2 means bar graph
  {

    float[] data=new float[6];
    for(int i=0;i<sixValues.length;i++)
    {
      //total+=s.totalWorkers;
      data[i]=sixValues[i]*360/tempState.totalWorkers;
      
    }
    
    //for(int i=0;i<states.size();i++)angles[i]=int(angles[i]/total*360);
    //print(angles[1]);

    if(abs(dist(mouseX,mouseY,width/2,height/4+20))<150)
    {
      for(aState s:states)s.highlighted=false;
      lookupByName(tempState.name).highlighted=true;
    }
    float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    float gray = map(i, 0, data.length, 0, 255);
    fill(top[i]);
    //noStroke();
    //if(doubleH!=-1&&doubleH==i)stroke(1);
    arc(width/2,height/4+20, 300,300, lastAngle, lastAngle+radians(data[i]));//if alignment problems see this line
    lastAngle += radians(data[i]);
  }
  }
  else
  {
    int x=0;
    int startAreay=height/2;
    int startAreax=width/2-116;
    line(startAreax-20,startAreay,startAreax-20,startAreay-300);
    line(startAreax-20,startAreay,startAreax+300,startAreay);
    for(int i=0;i<sixValues.length;i++){
      

      float h = map(sixValues[i], 0,max(sixValues),0,300);
      if(mouseX>x+startAreax && mouseX<=x+40+startAreax&&mouseY>startAreay-h&&mouseY<startAreay){
        for(aState s:states)s.highlighted=false;
        lookupByName(tempState.name).highlighted=true;
        doubleH=i;
        drawTip=true;
        mouseOverValue=sixValues[i];
        tipText=tempState.c;
      }
      fill(top[i]);
      //if(lookupByName(tempState.name).highlighted)fill(top[i]);
      //else fill(50);
      rect(startAreax+x,startAreay-h,32,h);
      x+=40;
    }}
  int x=0;
  int startAreay=height-40;
  int startAreax=200;
  String[] names=new String[3];
  float[] topThreeValues=new float[3];
  float maxValue=0;
  float[] h=new float[3];
  float displace;

  line(startAreax-20,startAreay,startAreax-20,startAreay-300);
  line(startAreax-20,startAreay,startAreax+850,startAreay);
  
  //aState tempRef;
  //line();
  
  for(int i=0;i<sixValues.length;i++){

    if(droplistoption.getValue()==2)topThreeValues=topThreePercent(i,maxValueFor);
    else topThreeValues=topThree(i,maxValueFor);
    if(maxValue<topThreeValues[0])maxValue=topThreeValues[0];
    //print(maxValue);
    displace=0;
    for(int j=0;j<h.length;j++)
    {
      if(droplistoption.getValue()==2)names[j]=findPercent(topThreeValues[j],i).name;
      else names[j]=findValue(topThreeValues[j],i).name;
      h[j]= map(topThreeValues[j],0,int(maxValue),0,300);
      //print(names[0]+names[1]+names[2]);
      if(mouseX>x+startAreax+displace+4 && mouseX<=x+displace+36+startAreax&&mouseY>startAreay-h[j]&&mouseY<startAreay){
        for(aState s:states)s.highlighted=false;
        lookupByName(names[j]).highlighted=true;
        drawTip=true;
        mouseOverValue=topThreeValues[j];
        //print(names[j]);
      }
      if(lookupByName(names[j]).highlighted)
      {
        fill(lookupByName(names[j]).c);
        tempState=lookupByName(names[j]);
        tipText=lookupByName(names[j]).c;
      }
      else fill(50);
      stroke(0);
      if(doubleH!=-1&&doubleH==i)stroke(255,0,0);
      rect(x+displace+startAreax+4,startAreay-h[j],32,h[j]);
      displace+=32;
    }
  
    //names[1]=findValue(topThreeValues[1],i).name;
    //names[2]=findValue(topThreeValues[2],i).name;
    //a good height for the bar graph

    x+=displace+48;

    //absolute second goes here 
  }
  if(drawTip){
   fill(0);
   rect(mouseX,mouseY-100,120,100,6); 
   fill(tipText);
   text(tempState.name,mouseX+10,mouseY-80);
   text(tempState.travelTime+" Average walk",mouseX+10,mouseY-64);
   text(mouseOverValue,mouseX+5,mouseY-48);
  }

}


class aState
{
  String name;
  float totalWorkers,droveAlone,carPooled,publicTrans,walk,other,home,travelTime;
  boolean highlighted;
  color c;
  aState(String n,float[] input)
  {
    highlighted=false;
    name=n;
    totalWorkers=input[0];
    droveAlone=input[1];
    carPooled=input[2];
    publicTrans=input[3];
    walk=input[4];
    other=input[5];
    home=input[6];
    travelTime=input[7];
  }
  String toString()
  {
    String ret=name+" "+totalWorkers+" "+droveAlone+" "+carPooled+" "+publicTrans+" "+walk+" "+other+" "+home+" "+travelTime;
    return ret;
    //println("name");
    //print(totalWorkers+" "+droveAlone+" "+carPooled+" "+publicTrans+" "+walk+" "+other+" "+home+" "+travelTime);
  }
  float[] getSixValues()
  {
    float[] tempArray=new float[6];
    tempArray[0]=droveAlone;
    tempArray[1]=carPooled;
    tempArray[2]=publicTrans;
    tempArray[3]=walk;
    tempArray[4]=other;
    tempArray[5]=home;
    return tempArray;

  }

  void highlight()
  {


  }

}
aState lookupByName(String name)
{
  for(aState s:states)
  {
    if(s.name.equals(name))return s;
  } 
  return states.get(0);
}
aState findValue(float value,int catagory)//returns the value from the catagory
{


  for(aState s:states)
  {
    if(s.getSixValues()[catagory]==value)return s;

  }
  return states.get(0);

}
aState findPercent(float value,int catagory)//returns the value from the catagory
{


  for(aState s:states)
  {
    if(s.getSixValues()[catagory]/s.totalWorkers*100==value)return s;

  }
  return states.get(0);

}
float[] topThree(int catagory,float top)//catagory refers to the same system as getSixVallues
{
  float[] tempFloat=new float[6];
  float[] compare=new float[51];
  //String[] ret=new String[3];
  int stateCounter=0;
  for(aState s:states)
  {

    tempFloat=s.getSixValues();
    if(tempFloat[catagory]<top)compare[stateCounter]=tempFloat[catagory];
    else compare[stateCounter]=0;
    stateCounter++;
  }
  compare=sort(compare);
  float[] ret={compare[50],compare[49],compare[48]};
  return ret;
  /*
    ret[0]=findValue(compare[50],catagory).name;
    ret[1]=findValue(compare[49],catagory).name;
    ret[2]=findValue(compare[48],catagory).name;
    return ret;
   */

}
float[] topThreePercent(int catagory,float top)//catagory refers to the same system as getSixVallues
{
  float[] tempFloat=new float[6];
  float[] compare=new float[51];
  //String[] ret=new String[3];
  int stateCounter=0;
  for(aState s:states)
  {

    tempFloat=s.getSixValues();
    if(tempFloat[catagory]/s.totalWorkers*100<top)compare[stateCounter]=tempFloat[catagory]/s.totalWorkers*100;
    else compare[stateCounter]=0;
    stateCounter++;
  }
  compare=sort(compare);
  float[] ret={compare[50],compare[49],compare[48]};
  return ret;

}

