/*
  "Chrystal smoke"
  Relationship (again/still)
  Generate points with the mouse input, and move them with repulsion forces.
  Optionally, draw a line from each point to its closest point
  I noticed that sometimes, a group of points can get "trapped" in a very small region and stops expanding (like black hole?)
*/

import java.util.Date;

int maxPoints = 1000; // Maximum number of total points
float speed = 0.008; // How fast they will move
float zoomSpeed = 0;
PVector cameraSpeed = new PVector();
color[] palette = {#E0CF7A, #F55225, #2E5E98, #894C1A};
color bgColor = 0;

ArrayList<PVector> points = new ArrayList();

void setup()
{
  size(900, 900);
  background(0);
  fill(bgColor, 31);
}

void draw()
{
  int nPoints = points.size();
  rect(0, 0, width, height);
  for(int i = 0; i < nPoints; i++)
  {
    PVector currentPoint = points.get(i);
    PVector closestPoint = null;
    float distanceToClosestPoint = -1;
    for(int j = 0; j < nPoints; j++)
    {
      if(i != j) {
        PVector anotherPoint = points.get(j);
        float distance = currentPoint.dist(anotherPoint);
        if(distanceToClosestPoint == -1 || distance < distanceToClosestPoint)
        {
          distanceToClosestPoint = distance;
          closestPoint = anotherPoint;
        }
      }
    }
    if(closestPoint != null)
    {
      int colorIndex = Math.max(0, Math.round(map(distanceToClosestPoint, 25, 60, 0, 3)))%4;
      strokeWeight(Math.min(1, 10/distanceToClosestPoint));
      color chosenColor = palette[colorIndex];
      stroke(chosenColor);
      line(currentPoint.x, currentPoint.y, closestPoint.x, closestPoint.y);
      PVector distance = new PVector(closestPoint.x - currentPoint.x, closestPoint.y - currentPoint.y);
      PVector displacement = new PVector(- distance.x * speed, - distance.y * speed); // Move points 
      displacement.x += zoomSpeed * (currentPoint.x - width/2);
      displacement.y += zoomSpeed * (currentPoint.y - height/2);
      displacement.add(cameraSpeed);
      points.get(i).add(displacement);
    }
  }
}

void mouseDragged()
{
  addPoint();
}

void mousePressed()
{
  addPoint();
}

void addPoint()
{
  if( ! ( points.size() < maxPoints) ) {
    points.remove(0);
  }
  points.add(new PVector(mouseX, mouseY));
}

void keyPressed() {
  switch(key) {
    case'c':
    // Clear the screen
      background(bgColor);
      break;
    case 's':
    // Save a screenshot
      Date date = new Date(); // Including the system time in the screenshot file name allows us to keep any screenshots we want instead of overriding the same file all the time
      String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd.kk.mm.ss").format(date.getTime());
      saveFrame("data/screenshot-" + formattedDate + ".png");
      break;
    case '-':
      zoomSpeed -= 0.002;
      break;
    case '+':
      zoomSpeed += 0.002;
      break;
    case ' ':
      zoomSpeed = 0;
      cameraSpeed.x = 0;
      cameraSpeed.y = 0;
      break;
  }
  switch(keyCode) {
    case UP:
      cameraSpeed.y += 0.2;
      break;
    case DOWN:
      cameraSpeed.y -= 0.2;
      break;
    case LEFT:
      cameraSpeed.x += 0.2;
      break;
    case RIGHT:
      cameraSpeed.x -= 0.2;
      break;
  }
}

