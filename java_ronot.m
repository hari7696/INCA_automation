import java.awt.Robot;
import java.awt.event.*;
robot = Robot;

for i=1:760
    % Coordinates (these are hypothetical and will need adjustment)
    xPosition = 819;
    yPosition = 247;
    
    % Move the mouse and click
    robot.mouseMove(xPosition, yPosition);  
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.delay(100);  % Delay to ensure the click is registered
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
    
    % Down button
    x_down = 904;
    y_down = 399;
    
    % Move the mouse and click
    robot.mouseMove(x_down, y_down);
    robot.delay(200);
    robot.mousePress(InputEvent.BUTTON1_MASK);
    robot.delay(200);  % Delay to ensure the click is registered
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
    robot.delay(1000);
    
    % Pause every 20th iteration
    if mod(i, 20) == 0
        pause(5);  % Pause for 1 second
    end
end

