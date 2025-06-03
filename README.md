# Java Web Library Management System

This is a Java web application for library management using Jakarta EE 10.

## Project Setup

### Prerequisites
- Java 17 or higher
- Maven 3.6 or higher
- A Jakarta EE compatible server (e.g., Tomcat 10.x, GlassFish 7.x, or similar)

### Build Instructions
1. Clone the repository
2. Navigate to the project root directory
3. Build the project using Maven:
   ```
   mvn clean package
   ```
4. Deploy the generated WAR file to your server

## Development

### IDE Setup
This project is set up as a Maven project. To import it into your IDE:

1. **Eclipse**:
   - File > Import > Maven > Existing Maven Projects
   - Browse to the project folder and select it

2. **IntelliJ IDEA**:
   - File > Open
   - Select the project folder
   - Choose to open as a Maven project when prompted

### Project Structure
- `src/main/java`: Java source files
- `src/main/webapp`: Web resources (JSP, HTML, CSS, etc.)
- `src/main/webapp/WEB-INF`: Web configuration files

## Troubleshooting

If you encounter "The import jakarta cannot be resolved" errors:
1. Make sure you have the correct Maven dependencies
2. Run `mvn clean install` to update dependencies
3. Refresh/update your project in your IDE

## Dependencies

The project uses Jakarta EE 10 Web API and related dependencies managed by Maven in the pom.xml file.
