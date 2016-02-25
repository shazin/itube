package com.github.shazin.itube.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/video")
public class VideoController {

	private String videoLocation = "videos";

	private ConcurrentHashMap<String, File> videos = new ConcurrentHashMap<String, File>();

	@PostConstruct
	public void init() {
		File dir = new File(videoLocation);
		videos.clear();
		videos.putAll(Arrays.asList(dir.listFiles()).stream()
				.collect(Collectors.toMap((f) -> {
					String name = ((File) f).getName();
					return name;
				}, (f) -> (File) f)));
	}

	@RequestMapping(method = RequestMethod.GET, value = "/{video:.+}")
	public StreamingResponseBody stream(@PathVariable String video)
			throws FileNotFoundException {
		File videoFile = videos.get(video);
		final InputStream videoFileStream = new FileInputStream(videoFile);
		return (os) -> {
			readAndWrite(videoFileStream, os);
		};
	}
	
	@RequestMapping(method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void upload(@RequestParam("file") MultipartFile file) throws IOException {
		OutputStream os = new FileOutputStream(new File(videoLocation, file.getOriginalFilename()));
		readAndWrite(file.getInputStream(), os);
		init();
	}

	@RequestMapping(method = RequestMethod.GET)
	public Set<String> list() {
		return videos.keySet();
	}
	
	private void readAndWrite(final InputStream is, OutputStream os)
			throws IOException {
		byte[] data = new byte[2048];
		int read = 0;
		while ((read = is.read(data)) > 0) {
			os.write(data, 0, read);
		}
		os.flush();
	}

}
