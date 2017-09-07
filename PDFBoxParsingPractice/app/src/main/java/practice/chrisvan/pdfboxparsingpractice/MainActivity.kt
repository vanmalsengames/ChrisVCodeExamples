package practice.chrisvan.pdfboxparsingpractice

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import com.tom_roush.pdfbox.util.PDFBoxResourceLoader
import android.content.Intent
import android.app.Activity
import android.net.Uri
import com.tom_roush.pdfbox.pdmodel.PDDocument
import android.util.Log
import android.widget.TextView
import com.tom_roush.pdfbox.text.PDFTextStripper
import java.io.IOException

val PICKFILE_REQUEST_CODE = 0

class MainActivity : AppCompatActivity() {

    var pdfButtonUploader : Button? = null
    var pdfTextView : TextView? = null

    var currentFilePath = String()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // upload button
        pdfButtonUploader = findViewById(R.id.upload_pdf_button) as Button
        pdfButtonUploader?.setOnClickListener {
            performFileSearch()
        }

        // pdf text view
        pdfTextView = findViewById(R.id.pdf_text) as TextView
    }

    override fun onStart() {
        super.onStart()
        setup()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        if (requestCode == PICKFILE_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val uri: Uri = data.data

            val inputStream = contentResolver.openInputStream(uri)

            // TODO: Place expensive task in async thread
            try {
                val pdfResume = PDDocument.load(inputStream)
                pdfAnalysis(pdfResume)
            } catch (e: IOException) {
                Log.d("location", "unable to load pdf" + e.toString())
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    /**
     * Initializes variables used for convenience
     */
    private fun setup() {

        // Enable Android-style asset loading (highly recommended)
        PDFBoxResourceLoader.init(applicationContext)
    }

    fun performFileSearch() {

        val intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.type = "application/pdf"

        intent.addCategory(Intent.CATEGORY_OPENABLE)

        startActivityForResult(Intent.createChooser(intent, resources.getString(R.string.main_activity_instructions)), PICKFILE_REQUEST_CODE)
    }

    fun pdfAnalysis(document : PDDocument) {

        if (pdfTextView != null) {

            var parsedText = String()

            try {
                val pdfStripper = PDFTextStripper()
                pdfStripper.startPage = 0
                pdfStripper.endPage = 1
                parsedText = "Parsed text: " + pdfStripper.getText(document)
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                try {
                    document?.close()
                } catch (e: Exception) {
                    e.printStackTrace()
                }

            }
            pdfTextView?.setText(parsedText)
        }
    }
}
