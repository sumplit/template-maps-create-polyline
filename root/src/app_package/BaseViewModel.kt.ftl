package ${packageName}

import android.Manifest
import android.app.Application
import android.arch.lifecycle.AndroidViewModel
import android.content.Context
import android.content.pm.PackageManager
import android.location.Geocoder
import android.support.v4.app.ActivityCompat
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import java.util.*

class ${className}ViewModel(context: Application): AndroidViewModel(context), OnMapReadyCallback {

	private val TAG = ${className}ViewModel::class.java.simpleName
	private var mContext: Context = context

	lateinit var mGoogleMap: GoogleMap

    var originLatLng: LatLng? = null

    var destinationLatLng: LatLng? = null

    var markerOptions: MarkerOptions? = null
    
	override fun onMapReady(googleMap: GoogleMap?) {

		if (googleMap != null) {
			
			mGoogleMap = googleMap

            mGoogleMap.setOnMapLongClickListener(object : GoogleMap.OnMapLongClickListener {
                override fun onMapLongClick(p0: LatLng) {
                    processRouting(p0)
                }

            })

		}

	}

    private fun processRouting(p0: LatLng) {

        if (originLatLng == null) {
            markerOptions = MarkerOptions().position(p0).icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_RED))
            mGoogleMap.addMarker(markerOptions)
            originLatLng = p0
        } else if (destinationLatLng == null) {
            markerOptions = MarkerOptions().position(p0).icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_BLUE))
            mGoogleMap.addMarker(markerOptions)
            destinationLatLng = p0

            val directions = routingPolyline(originLatLng ?: LatLng(0.0, 0.0), destinationLatLng
                    ?: LatLng(0.0, 0.0))

            if (directions != null) {
                setCamera(originLatLng, destinationLatLng)
                val decodedPath = PolyUtil.decode(directions.routes[0].overviewPolyline.getEncodedPath())
                mGoogleMap.addPolyline(PolylineOptions().color(Color.BLUE).width(5f).addAll(decodedPath))
            }

        } else {
            mGoogleMap.clear()
            originLatLng = null
            destinationLatLng = null
        }

    }

    private fun setCamera(originLatLng: LatLng?, destinationLatLng: LatLng?) {

        val latLongBuilder = LatLngBounds.Builder()
        latLongBuilder.include(originLatLng)
        latLongBuilder.include(destinationLatLng)

        val bounds = latLongBuilder.build()

        val width = mContext.resources.displayMetrics.widthPixels
        val height = mContext.resources.displayMetrics.heightPixels
        val padding = (width * 0.30).toInt()

        val cameraUpdateFactory = CameraUpdateFactory.newLatLngBounds(bounds, width, height, padding)
        mGoogleMap.animateCamera(cameraUpdateFactory)
    }

    private fun routingPolyline(origin: LatLng, destination: LatLng): DirectionsResult? {

        val context = GeoApiContext().setApiKey("API KEY")
        val stringOrigin = origin.latitude.toString() + "," + origin.longitude.toString()
        val stringDestination = destination.latitude.toString() + "," + destination.longitude.toString()

        val result = DirectionsApi.newRequest(
                context)
                .mode(TravelMode.DRIVING) // Menggunakan Roda Empat
                .alternatives(true)
                .origin(stringOrigin).destination(stringDestination).await()

        return result

    }

	
	
}