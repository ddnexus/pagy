// capture.js
const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');

// --- Configuration ---
const appURL = process.argv[2] || 'http://127.0.0.1:8088';
const outputDir = process.argv[3] || path.join(__dirname, 'screenshots');
const screenshotTargetSelector = '#target .backdrop';
const filenameSelector = '#target .filename';
const linksContainerSelector = '#links';
const linkSelector = `${linksContainerSelector} a[href]`;
// --- End Configuration ---

async function captureScreenshots() {
  console.log('Starting screenshot capture...');
  let browser = null;

  try {
    // Ensure output directory exists
    console.log(`Ensuring output directory exists: ${outputDir}`);
    fs.mkdirSync(outputDir, { recursive: true });

    console.log('Launching Puppeteer...');
    browser = await puppeteer.launch({
                                       // headless: false, // Uncomment for debugging to see the browser
                                       // slowMo: 50,      // Uncomment to slow down operations for debugging
                                     });
    const page = await browser.newPage();

    console.log(`Navigating to initial URL: ${appURL}`);
    await page.goto(appURL, { waitUntil: 'networkidle0' });
    console.log('Initial page loaded.');
    let visitedCount = 0;
    const initialPageUrl = page.url(); // Store base URL for resolving relative links

    // --- 1. Capture Initial Page ---
    console.log(`\nProcessing initial page: ${initialPageUrl}`);
    await page.waitForSelector(filenameSelector, { visible: true });
    await page.waitForSelector(screenshotTargetSelector, { visible: true });
    await page.waitForSelector(linksContainerSelector, { visible: true });

    const initialFilename = await page.$eval(filenameSelector, el => el.textContent.trim());
    if (initialFilename && initialFilename.endsWith('.png')) {
      const initialElement = await page.$(screenshotTargetSelector);
      if (initialElement) {
        const initialScreenshotPath = path.join(outputDir, initialFilename);
        console.log(`   Taking screenshot: ${initialScreenshotPath}`);
        await initialElement.screenshot({
                                          path: initialScreenshotPath,
                                          omitBackground: true,
                                        });
        visitedCount++;
      } else {
        console.warn(`   [WARN] Could not find element '${screenshotTargetSelector}' on initial page.`);
      }
    } else {
      console.warn(`   [WARN] Could not extract valid .png filename from '${filenameSelector}' on initial page. Found: "${initialFilename}". Skipping screenshot.`);
    }

    // --- 2. Collect Links ---
    console.log('\nCollecting links from initial page...');
    const linkHandles = await page.$$(linkSelector);
    const linkHrefs = [];
    for (const linkHandle of linkHandles) {
      const href = await linkHandle.evaluate(a => a.getAttribute('href'));
      linkHrefs.push(href);
    }

    // --- 3. Remove first link (assuming it's the current page) ---
    const remainingHrefs = linkHrefs.slice(1); // Create a new array excluding the first element
    console.log(`   Collected ${linkHrefs.length} links. Processing ${remainingHrefs.length} remaining links.`);

    // --- 4. Iterate and Capture Remaining Links ---
    for (const relativeHref of remainingHrefs) {
      // Construct full URL (handles both absolute and relative hrefs)
      const targetUrl = new URL(relativeHref, initialPageUrl).toString();
      console.log(`\nProcessing link: ${relativeHref} -> ${targetUrl}`);

      try {
        console.log(`   Navigating to ${targetUrl}...`);
        await page.goto(targetUrl, { waitUntil: 'networkidle0', timeout: 20000 }); // Increased timeout

        // Wait for elements on the new page
        await page.waitForSelector(filenameSelector, { visible: true, timeout: 15000 });
        await page.waitForSelector(screenshotTargetSelector, { visible: true, timeout: 5000 }); // Shorter timeout as it should be there if filename is

        // Extract filename and take screenshot
        const filename = await page.$eval(filenameSelector, el => el.textContent.trim());
        if (!filename || !filename.endsWith('.png')) {
          console.warn(`   [WARN] Could not extract valid .png filename from '${filenameSelector}'. Found: "${filename}". Skipping screenshot for this page.`);
          continue; // Skip to the next link
        }

        const elementToScreenshot = await page.$(screenshotTargetSelector);
        if (!elementToScreenshot) {
          console.warn(`   [WARN] Could not find element '${screenshotTargetSelector}' on page ${targetUrl}. Skipping screenshot.`);
          continue; // Skip to the next link
        }

        const screenshotPath = path.join(outputDir, filename);
        console.log(`   Taking screenshot: ${screenshotPath}`);
        await elementToScreenshot.screenshot({
                                               path: screenshotPath,
                                               omitBackground: true,
                                             });
        visitedCount++;

      } catch (navError) {
        console.error(`   [ERROR] Failed to process ${targetUrl}: ${navError.message}. Skipping this link.`);
        // Continue to the next link even if one fails
      }
    } // End for loop

    console.log(`\nSuccessfully captured ${visitedCount} screenshots.`);

  } catch (error) {
    console.error('\n--- An error occurred during screenshot capture ---');
    console.error(error);
    process.exitCode = 1; // Indicate failure
  } finally {
    // Cleanup
    if (browser) {
      console.log('Closing browser...');
      await browser.close();
      console.log('Browser closed.');
    }
  }
}

// Run the main function
captureScreenshots();
