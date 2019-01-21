<layout xmlns:android="http://schemas.android.com/apk/res/android"
		xmlns:tools="http://schemas.android.com/tools"
		xmlns:app="http://schemas.android.com/apk/res-auto">

	<data>

        <import type="android.view.View" />
        
		<variable
			name="mViewModel"
			type="${packageName}.${className}ViewModel" />

		<variable
			name="mListener"
			type="${packageName}.${className}UserActionListener" />				
	</data>
	
	<RelativeLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent">

        <com.google.android.gms.maps.MapView
            android:id="@+id/maps"
            android:layout_width="match_parent"
            android:layout_height="match_parent" />

    </RelativeLayout>

</layout>