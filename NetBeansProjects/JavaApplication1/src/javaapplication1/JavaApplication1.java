/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author fronchetti
 */
public class JavaApplication1 {

    public static final String[] FILENAMES = {
        "first_contributions.txt", "newcomers_contributions_pulls.eps", "newcomers_contributions_pulls.png", "newcomers_forks_stars.eps", "newcomers_forks_stars.png", "pulls_opened_closed_merged.eps", "pulls_opened_closed_merged.png"
    };

    public static void main(String[] args) throws Exception {
        File dir = new File("D:\\Dropbox\\Faculdade\\Engenharia Empírica\\Dataset");
//        File outDir = new File("/home/fronchetti/Foi");

        for (File langDir : files(dir)) {
            for (File projDir : files(langDir)) {

                String index = langDir.getName() + "\\" + projDir.getName() + "\\" + projDir.getName() + "_first_contributions.txt";
//                String newFileName = projDir.getName() + "_first_contributions.txt";

                Methods met = new Methods();
                int count = met.countLines("D:\\Dropbox\\Faculdade\\Engenharia Empírica\\Dataset\\" + index);
//                System.out.println(count);
                System.out.println(langDir.getName() + " " + projDir.getName() + " " + count);
//                for (String fileName : FILENAMES) {
//                    File sourceFile = new File(projDir, fileName);
//                    File destinyFile = new File(outDir, index + "/" + projDir.getName() + "_" + fileName);
//
//                    System.out.println("Will copy " + index + " >> " + fileName);
//                    System.out.println("Will create mkdir " + destinyFile.getAbsolutePath());
//                    System.out.println("Will copy \"" + sourceFile.getAbsolutePath() + "\" to \"" + destinyFile.getAbsolutePath() + "\"");
//                    destinyFile.getParentFile().mkdirs();
//                    Files.copy(sourceFile.toPath(), destinyFile.toPath());
//                }

//                System.out.println("Acabou " + index);
            }
        }
    }

    private static List<File> files(File dir) throws Exception {
        DirectoryStream<Path> stream = Files.newDirectoryStream(dir.toPath());
        List<File> list = new ArrayList<File>();

        for (Path path : stream) {
            list.add(path.toFile());
        }

        return list;
    }
}
