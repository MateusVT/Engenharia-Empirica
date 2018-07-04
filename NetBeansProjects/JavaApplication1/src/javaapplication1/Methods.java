/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1;

import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;

/**
 *
 * @author Torres
 */
public class Methods {

    public int countLines(String filename) throws IOException {
        LineNumberReader reader = new LineNumberReader(new FileReader(filename));
        int cnt = 0;
        String lineRead = "";
        while ((lineRead = reader.readLine()) != null) {
        }

        cnt = reader.getLineNumber();
        reader.close();
        return cnt;
    }
}
