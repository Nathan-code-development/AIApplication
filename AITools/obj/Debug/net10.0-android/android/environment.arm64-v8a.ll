; ModuleID = 'environment.arm64-v8a.ll'
source_filename = "environment.arm64-v8a.ll"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-android21"

%struct.ApplicationConfig = type {
	i1, ; bool uses_mono_llvm
	i1, ; bool uses_mono_aot
	i1, ; bool aot_lazy_load
	i1, ; bool uses_assembly_preload
	i1, ; bool broken_exception_transitions
	i1, ; bool jni_add_native_method_registration_attribute_present
	i1, ; bool have_runtime_config_blob
	i1, ; bool have_assemblies_blob
	i1, ; bool marshal_methods_enabled
	i1, ; bool ignore_split_configs
	i8, ; uint8_t bound_stream_io_exception_type
	i32, ; uint32_t package_naming_policy
	i32, ; uint32_t environment_variable_count
	i32, ; uint32_t system_property_count
	i32, ; uint32_t number_of_assemblies_in_apk
	i32, ; uint32_t bundled_assembly_name_width
	i32, ; uint32_t number_of_dso_cache_entries
	i32, ; uint32_t number_of_aot_cache_entries
	i32, ; uint32_t number_of_shared_libraries
	i32, ; uint32_t android_runtime_jnienv_class_token
	i32, ; uint32_t jnienv_initialize_method_token
	i32, ; uint32_t jnienv_registerjninatives_method_token
	i32, ; uint32_t jni_remapping_replacement_type_count
	i32, ; uint32_t jni_remapping_replacement_method_index_entry_count
	i32, ; uint32_t mono_components_mask
	ptr, ; char* android_package_name
	i1 ; bool managed_marshal_methods_lookup_enabled
}

%struct.AssemblyStoreAssemblyDescriptor = type {
	i32, ; uint32_t data_offset
	i32, ; uint32_t data_size
	i32, ; uint32_t debug_data_offset
	i32, ; uint32_t debug_data_size
	i32, ; uint32_t config_data_offset
	i32 ; uint32_t config_data_size
}

%struct.AssemblyStoreRuntimeData = type {
	ptr, ; uint8_t data_start
	i32, ; uint32_t assembly_count
	i32, ; uint32_t index_entry_count
	ptr ; AssemblyStoreAssemblyDescriptor assemblies
}

%struct.AssemblyStoreSingleAssemblyRuntimeData = type {
	ptr, ; uint8_t image_data
	ptr, ; uint8_t debug_info_data
	ptr, ; uint8_t config_data
	ptr ; AssemblyStoreAssemblyDescriptor descriptor
}

%struct.DSOApkEntry = type {
	i64, ; uint64_t name_hash
	i32, ; uint32_t offset
	i32 ; int32_t fd
}

%struct.DSOCacheEntry = type {
	i64, ; uint64_t hash
	i64, ; uint64_t real_name_hash
	i1, ; bool ignore
	i1, ; bool is_jni_library
	ptr, ; char* name
	ptr ; void* handle
}

%struct.XamarinAndroidBundledAssembly = type {
	i32, ; int32_t file_fd
	ptr, ; char* file_name
	i32, ; uint32_t data_offset
	i32, ; uint32_t data_size
	ptr, ; uint8_t data
	i32, ; uint32_t name_length
	ptr ; char* name
}

; 0x25e6972616d58
@format_tag = dso_local local_unnamed_addr constant i64 666756936985944, align 8

@mono_aot_mode_name = dso_local local_unnamed_addr constant ptr @.env.0, align 8

; Application environment variables array, name:value
@app_environment_variables = dso_local local_unnamed_addr constant [6 x ptr] [
	ptr @.env.var.0, ; 0 ('MONO_GC_PARAMS')
	ptr @.env.var.1, ; 1 ('major=marksweep-conc')
	ptr @.env.var.2, ; 2 ('MONO_LOG_LEVEL')
	ptr @.env.var.3, ; 3 ('info')
	ptr @.env.var.4, ; 4 ('XA_HTTP_CLIENT_HANDLER_TYPE')
	ptr @.env.var.5 ; 5 ('Xamarin.Android.Net.AndroidMessageHandler')
], align 8

; System properties defined by the application
@app_system_properties = dso_local local_unnamed_addr constant [0 x ptr] zeroinitializer, align 8

@application_config = dso_local local_unnamed_addr constant %struct.ApplicationConfig {
	i1 false, ; bool uses_mono_llvm
	i1 true, ; bool uses_mono_aot
	i1 false, ; bool aot_lazy_load
	i1 false, ; bool uses_assembly_preload
	i1 false, ; bool broken_exception_transitions
	i1 false, ; bool jni_add_native_method_registration_attribute_present
	i1 true, ; bool have_runtime_config_blob
	i1 false, ; bool have_assemblies_blob
	i1 false, ; bool marshal_methods_enabled
	i1 false, ; bool ignore_split_configs
	i8 0, ; uint8_t bound_stream_io_exception_type
	i32 3, ; uint32_t package_naming_policy
	i32 6, ; uint32_t environment_variable_count
	i32 0, ; uint32_t system_property_count
	i32 327, ; uint32_t number_of_assemblies_in_apk
	i32 69, ; uint32_t bundled_assembly_name_width
	i32 40, ; uint32_t number_of_dso_cache_entries
	i32 0, ; uint32_t number_of_aot_cache_entries
	i32 10, ; uint32_t number_of_shared_libraries
	i32 u0x02001416, ; uint32_t android_runtime_jnienv_class_token
	i32 u0x06014f5b, ; uint32_t jnienv_initialize_method_token
	i32 u0x06014f58, ; uint32_t jnienv_registerjninatives_method_token
	i32 0, ; uint32_t jni_remapping_replacement_type_count
	i32 0, ; uint32_t jni_remapping_replacement_method_index_entry_count
	i32 u0x00000003, ; uint32_t mono_components_mask
	ptr @.ApplicationConfig.0_android_package_name, ; char* android_package_name
	i1 false; bool managed_marshal_methods_lookup_enabled
}, align 8

; DSO cache entries
@dso_cache = dso_local local_unnamed_addr global [40 x %struct.DSOCacheEntry] [
	%struct.DSOCacheEntry {
		i64 u0x01848c0093f0afd8, ; from name: libSystem.Security.Cryptography.Native.Android
		i64 u0x4818e42ca66bbd75, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.3_name, ; name: libSystem.Security.Cryptography.Native.Android.so
		ptr null; void* handle
	}, ; 0
	%struct.DSOCacheEntry {
		i64 u0x04bb981b3c3ff40f, ; from name: System.Security.Cryptography.Native.Android.so
		i64 u0x4818e42ca66bbd75, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.3_name, ; name: libSystem.Security.Cryptography.Native.Android.so
		ptr null; void* handle
	}, ; 1
	%struct.DSOCacheEntry {
		i64 u0x0582d422de762780, ; from name: libmono-component-marshal-ilgen.so
		i64 u0x0582d422de762780, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.6_name, ; name: libmono-component-marshal-ilgen.so
		ptr null; void* handle
	}, ; 2
	%struct.DSOCacheEntry {
		i64 u0x07e1516b937259a4, ; from name: System.Globalization.Native.so
		i64 u0x74b568291c419777, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.0_name, ; name: libSystem.Globalization.Native.so
		ptr null; void* handle
	}, ; 3
	%struct.DSOCacheEntry {
		i64 u0x1a1918dd01662b19, ; from name: libmonosgen-2.0.so
		i64 u0x1a1918dd01662b19, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.7_name, ; name: libmonosgen-2.0.so
		ptr null; void* handle
	}, ; 4
	%struct.DSOCacheEntry {
		i64 u0x21cc3326a27c28e1, ; from name: xamarin-debug-app-helper.so
		i64 u0x641102ea13f025b2, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.9_name, ; name: libxamarin-debug-app-helper.so
		ptr null; void* handle
	}, ; 5
	%struct.DSOCacheEntry {
		i64 u0x28b5c8fca080abd5, ; from name: libSystem.Globalization.Native
		i64 u0x74b568291c419777, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.0_name, ; name: libSystem.Globalization.Native.so
		ptr null; void* handle
	}, ; 6
	%struct.DSOCacheEntry {
		i64 u0x2b87bb6ac8822015, ; from name: libmonodroid
		i64 u0x4434c7fd110c8d8b, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.8_name, ; name: libmonodroid.so
		ptr null; void* handle
	}, ; 7
	%struct.DSOCacheEntry {
		i64 u0x3807dd20062deb45, ; from name: monodroid
		i64 u0x4434c7fd110c8d8b, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.8_name, ; name: libmonodroid.so
		ptr null; void* handle
	}, ; 8
	%struct.DSOCacheEntry {
		i64 u0x40f32024ffd1c0be, ; from name: System.IO.Compression.Native.so
		i64 u0xc3cb80650fe5a0ab, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.1_name, ; name: libSystem.IO.Compression.Native.so
		ptr null; void* handle
	}, ; 9
	%struct.DSOCacheEntry {
		i64 u0x4434c7fd110c8d8b, ; from name: libmonodroid.so
		i64 u0x4434c7fd110c8d8b, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.8_name, ; name: libmonodroid.so
		ptr null; void* handle
	}, ; 10
	%struct.DSOCacheEntry {
		i64 u0x4818e42ca66bbd75, ; from name: libSystem.Security.Cryptography.Native.Android.so
		i64 u0x4818e42ca66bbd75, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.3_name, ; name: libSystem.Security.Cryptography.Native.Android.so
		ptr null; void* handle
	}, ; 11
	%struct.DSOCacheEntry {
		i64 u0x486aa459231fc98b, ; from name: mono-component-hot_reload
		i64 u0xb9c2fcad5704a3c9, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.5_name, ; name: libmono-component-hot_reload.so
		ptr null; void* handle
	}, ; 12
	%struct.DSOCacheEntry {
		i64 u0x49959b1b390dc809, ; from name: xamarin-debug-app-helper
		i64 u0x641102ea13f025b2, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.9_name, ; name: libxamarin-debug-app-helper.so
		ptr null; void* handle
	}, ; 13
	%struct.DSOCacheEntry {
		i64 u0x4cd7bd0032e920e1, ; from name: libSystem.Native
		i64 u0xa337ccc8aef94267, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.2_name, ; name: libSystem.Native.so
		ptr null; void* handle
	}, ; 14
	%struct.DSOCacheEntry {
		i64 u0x61c4cca6c77a9014, ; from name: libmonosgen-2.0
		i64 u0x1a1918dd01662b19, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.7_name, ; name: libmonosgen-2.0.so
		ptr null; void* handle
	}, ; 15
	%struct.DSOCacheEntry {
		i64 u0x641102ea13f025b2, ; from name: libxamarin-debug-app-helper.so
		i64 u0x641102ea13f025b2, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.9_name, ; name: libxamarin-debug-app-helper.so
		ptr null; void* handle
	}, ; 16
	%struct.DSOCacheEntry {
		i64 u0x6f9c86874c77b639, ; from name: libmono-component-debugger.so
		i64 u0x6f9c86874c77b639, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.4_name, ; name: libmono-component-debugger.so
		ptr null; void* handle
	}, ; 17
	%struct.DSOCacheEntry {
		i64 u0x74b568291c419777, ; from name: libSystem.Globalization.Native.so
		i64 u0x74b568291c419777, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.0_name, ; name: libSystem.Globalization.Native.so
		ptr null; void* handle
	}, ; 18
	%struct.DSOCacheEntry {
		i64 u0x81bc2b0b52670f30, ; from name: System.Security.Cryptography.Native.Android
		i64 u0x4818e42ca66bbd75, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.3_name, ; name: libSystem.Security.Cryptography.Native.Android.so
		ptr null; void* handle
	}, ; 19
	%struct.DSOCacheEntry {
		i64 u0x9190f4cb761b1d3c, ; from name: libSystem.IO.Compression.Native
		i64 u0xc3cb80650fe5a0ab, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.1_name, ; name: libSystem.IO.Compression.Native.so
		ptr null; void* handle
	}, ; 20
	%struct.DSOCacheEntry {
		i64 u0x936d971cc035eac2, ; from name: mono-component-marshal-ilgen
		i64 u0x0582d422de762780, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.6_name, ; name: libmono-component-marshal-ilgen.so
		ptr null; void* handle
	}, ; 21
	%struct.DSOCacheEntry {
		i64 u0x9c62065cdbdf43a5, ; from name: monosgen-2.0
		i64 u0x1a1918dd01662b19, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.7_name, ; name: libmonosgen-2.0.so
		ptr null; void* handle
	}, ; 22
	%struct.DSOCacheEntry {
		i64 u0x9ff54ae8a9311b68, ; from name: System.Native
		i64 u0xa337ccc8aef94267, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.2_name, ; name: libSystem.Native.so
		ptr null; void* handle
	}, ; 23
	%struct.DSOCacheEntry {
		i64 u0xa337ccc8aef94267, ; from name: libSystem.Native.so
		i64 u0xa337ccc8aef94267, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.2_name, ; name: libSystem.Native.so
		ptr null; void* handle
	}, ; 24
	%struct.DSOCacheEntry {
		i64 u0xa76ab5a3894f5a01, ; from name: System.Globalization.Native
		i64 u0x74b568291c419777, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.0_name, ; name: libSystem.Globalization.Native.so
		ptr null; void* handle
	}, ; 25
	%struct.DSOCacheEntry {
		i64 u0xab177aa6a32873ac, ; from name: monodroid.so
		i64 u0x4434c7fd110c8d8b, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.8_name, ; name: libmonodroid.so
		ptr null; void* handle
	}, ; 26
	%struct.DSOCacheEntry {
		i64 u0xb5c2ff9910024930, ; from name: libmono-component-debugger
		i64 u0x6f9c86874c77b639, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.4_name, ; name: libmono-component-debugger.so
		ptr null; void* handle
	}, ; 27
	%struct.DSOCacheEntry {
		i64 u0xb9c2fcad5704a3c9, ; from name: libmono-component-hot_reload.so
		i64 u0xb9c2fcad5704a3c9, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.5_name, ; name: libmono-component-hot_reload.so
		ptr null; void* handle
	}, ; 28
	%struct.DSOCacheEntry {
		i64 u0xb9c4d8821da5c5de, ; from name: mono-component-hot_reload.so
		i64 u0xb9c2fcad5704a3c9, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.5_name, ; name: libmono-component-hot_reload.so
		ptr null; void* handle
	}, ; 29
	%struct.DSOCacheEntry {
		i64 u0xc20cd752ee7ce28d, ; from name: libxamarin-debug-app-helper
		i64 u0x641102ea13f025b2, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 true, ; bool is_jni_library
		ptr @.DSOCacheEntry.9_name, ; name: libxamarin-debug-app-helper.so
		ptr null; void* handle
	}, ; 30
	%struct.DSOCacheEntry {
		i64 u0xc3cb80650fe5a0ab, ; from name: libSystem.IO.Compression.Native.so
		i64 u0xc3cb80650fe5a0ab, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.1_name, ; name: libSystem.IO.Compression.Native.so
		ptr null; void* handle
	}, ; 31
	%struct.DSOCacheEntry {
		i64 u0xc7bf0aae66d69fe4, ; from name: mono-component-debugger.so
		i64 u0x6f9c86874c77b639, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.4_name, ; name: libmono-component-debugger.so
		ptr null; void* handle
	}, ; 32
	%struct.DSOCacheEntry {
		i64 u0xd334d108d628ab4f, ; from name: System.IO.Compression.Native
		i64 u0xc3cb80650fe5a0ab, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.1_name, ; name: libSystem.IO.Compression.Native.so
		ptr null; void* handle
	}, ; 33
	%struct.DSOCacheEntry {
		i64 u0xd565cc57ed541a90, ; from name: monosgen-2.0.so
		i64 u0x1a1918dd01662b19, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.7_name, ; name: libmonosgen-2.0.so
		ptr null; void* handle
	}, ; 34
	%struct.DSOCacheEntry {
		i64 u0xde69d0ab38ed00d3, ; from name: mono-component-debugger
		i64 u0x6f9c86874c77b639, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.4_name, ; name: libmono-component-debugger.so
		ptr null; void* handle
	}, ; 35
	%struct.DSOCacheEntry {
		i64 u0xde6fb4b955d66724, ; from name: libmono-component-marshal-ilgen
		i64 u0x0582d422de762780, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.6_name, ; name: libmono-component-marshal-ilgen.so
		ptr null; void* handle
	}, ; 36
	%struct.DSOCacheEntry {
		i64 u0xe02ec096c271894c, ; from name: libmono-component-hot_reload
		i64 u0xb9c2fcad5704a3c9, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.5_name, ; name: libmono-component-hot_reload.so
		ptr null; void* handle
	}, ; 37
	%struct.DSOCacheEntry {
		i64 u0xe0d15587b4505ecd, ; from name: mono-component-marshal-ilgen.so
		i64 u0x0582d422de762780, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.6_name, ; name: libmono-component-marshal-ilgen.so
		ptr null; void* handle
	}, ; 38
	%struct.DSOCacheEntry {
		i64 u0xecb906ed9649ed1c, ; from name: System.Native.so
		i64 u0xa337ccc8aef94267, ; uint64_t real_name_hash
		i1 false, ; bool ignore
		i1 false, ; bool is_jni_library
		ptr @.DSOCacheEntry.2_name, ; name: libSystem.Native.so
		ptr null; void* handle
	} ; 39
], align 8

@dso_jni_preloads_idx_stride = dso_local local_unnamed_addr constant i32 4, align 4

@dso_jni_preloads_idx_count = dso_local local_unnamed_addr constant i64 8, align 8

; Indices into dso_cache[] of DSO libraries to preload because of JNI use
@dso_jni_preloads_idx = dso_local local_unnamed_addr constant [8 x i32] [
	i32 11, ; libSystem.Security.Cryptography.Native.Android.so
	i32 0, ; libSystem.Security.Cryptography.Native.Android
	i32 1, ; System.Security.Cryptography.Native.Android.so
	i32 19, ; System.Security.Cryptography.Native.Android
	i32 16, ; libxamarin-debug-app-helper.so
	i32 30, ; libxamarin-debug-app-helper
	i32 5, ; xamarin-debug-app-helper.so
	i32 13 ; xamarin-debug-app-helper
], align 4

; AOT DSO cache entries
@aot_dso_cache = dso_local local_unnamed_addr global [0 x %struct.DSOCacheEntry] zeroinitializer, align 8

@dso_apk_entries = dso_local local_unnamed_addr global [10 x %struct.DSOApkEntry] zeroinitializer, align 8

@_XamarinAndroidBundledAssembly_file_name_0_0 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_0_0 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_1_1 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_1_1 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_2_2 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_2_2 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_3_3 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_3_3 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_4_4 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_4_4 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_5_5 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_5_5 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_6_6 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_6_6 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_7_7 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_7_7 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_8_8 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_8_8 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_9_9 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_9_9 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a_a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a_a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b_b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b_b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c_c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c_c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d_d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d_d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e_e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e_e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f_f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f_f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_10_10 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_10_10 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_11_11 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_11_11 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_12_12 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_12_12 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_13_13 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_13_13 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_14_14 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_14_14 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_15_15 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_15_15 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_16_16 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_16_16 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_17_17 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_17_17 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_18_18 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_18_18 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_19_19 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_19_19 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_1a_1a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_1a_1a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_1b_1b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_1b_1b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_1c_1c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_1c_1c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_1d_1d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_1d_1d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_1e_1e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_1e_1e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_1f_1f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_1f_1f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_20_20 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_20_20 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_21_21 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_21_21 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_22_22 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_22_22 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_23_23 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_23_23 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_24_24 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_24_24 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_25_25 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_25_25 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_26_26 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_26_26 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_27_27 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_27_27 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_28_28 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_28_28 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_29_29 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_29_29 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_2a_2a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_2a_2a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_2b_2b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_2b_2b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_2c_2c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_2c_2c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_2d_2d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_2d_2d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_2e_2e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_2e_2e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_2f_2f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_2f_2f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_30_30 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_30_30 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_31_31 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_31_31 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_32_32 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_32_32 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_33_33 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_33_33 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_34_34 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_34_34 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_35_35 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_35_35 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_36_36 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_36_36 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_37_37 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_37_37 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_38_38 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_38_38 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_39_39 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_39_39 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_3a_3a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_3a_3a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_3b_3b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_3b_3b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_3c_3c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_3c_3c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_3d_3d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_3d_3d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_3e_3e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_3e_3e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_3f_3f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_3f_3f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_40_40 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_40_40 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_41_41 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_41_41 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_42_42 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_42_42 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_43_43 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_43_43 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_44_44 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_44_44 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_45_45 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_45_45 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_46_46 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_46_46 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_47_47 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_47_47 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_48_48 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_48_48 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_49_49 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_49_49 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_4a_4a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_4a_4a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_4b_4b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_4b_4b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_4c_4c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_4c_4c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_4d_4d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_4d_4d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_4e_4e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_4e_4e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_4f_4f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_4f_4f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_50_50 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_50_50 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_51_51 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_51_51 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_52_52 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_52_52 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_53_53 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_53_53 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_54_54 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_54_54 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_55_55 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_55_55 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_56_56 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_56_56 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_57_57 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_57_57 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_58_58 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_58_58 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_59_59 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_59_59 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_5a_5a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_5a_5a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_5b_5b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_5b_5b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_5c_5c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_5c_5c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_5d_5d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_5d_5d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_5e_5e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_5e_5e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_5f_5f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_5f_5f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_60_60 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_60_60 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_61_61 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_61_61 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_62_62 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_62_62 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_63_63 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_63_63 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_64_64 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_64_64 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_65_65 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_65_65 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_66_66 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_66_66 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_67_67 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_67_67 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_68_68 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_68_68 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_69_69 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_69_69 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_6a_6a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_6a_6a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_6b_6b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_6b_6b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_6c_6c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_6c_6c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_6d_6d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_6d_6d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_6e_6e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_6e_6e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_6f_6f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_6f_6f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_70_70 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_70_70 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_71_71 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_71_71 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_72_72 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_72_72 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_73_73 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_73_73 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_74_74 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_74_74 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_75_75 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_75_75 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_76_76 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_76_76 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_77_77 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_77_77 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_78_78 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_78_78 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_79_79 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_79_79 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_7a_7a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_7a_7a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_7b_7b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_7b_7b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_7c_7c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_7c_7c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_7d_7d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_7d_7d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_7e_7e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_7e_7e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_7f_7f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_7f_7f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_80_80 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_80_80 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_81_81 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_81_81 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_82_82 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_82_82 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_83_83 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_83_83 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_84_84 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_84_84 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_85_85 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_85_85 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_86_86 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_86_86 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_87_87 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_87_87 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_88_88 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_88_88 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_89_89 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_89_89 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_8a_8a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_8a_8a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_8b_8b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_8b_8b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_8c_8c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_8c_8c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_8d_8d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_8d_8d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_8e_8e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_8e_8e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_8f_8f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_8f_8f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_90_90 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_90_90 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_91_91 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_91_91 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_92_92 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_92_92 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_93_93 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_93_93 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_94_94 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_94_94 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_95_95 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_95_95 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_96_96 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_96_96 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_97_97 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_97_97 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_98_98 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_98_98 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_99_99 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_99_99 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_9a_9a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_9a_9a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_9b_9b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_9b_9b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_9c_9c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_9c_9c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_9d_9d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_9d_9d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_9e_9e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_9e_9e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_9f_9f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_9f_9f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a0_a0 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a0_a0 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a1_a1 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a1_a1 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a2_a2 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a2_a2 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a3_a3 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a3_a3 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a4_a4 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a4_a4 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a5_a5 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a5_a5 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a6_a6 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a6_a6 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a7_a7 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a7_a7 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a8_a8 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a8_a8 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_a9_a9 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_a9_a9 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_aa_aa = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_aa_aa = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ab_ab = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ab_ab = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ac_ac = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ac_ac = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ad_ad = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ad_ad = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ae_ae = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ae_ae = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_af_af = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_af_af = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b0_b0 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b0_b0 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b1_b1 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b1_b1 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b2_b2 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b2_b2 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b3_b3 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b3_b3 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b4_b4 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b4_b4 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b5_b5 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b5_b5 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b6_b6 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b6_b6 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b7_b7 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b7_b7 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b8_b8 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b8_b8 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_b9_b9 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_b9_b9 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ba_ba = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ba_ba = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_bb_bb = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_bb_bb = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_bc_bc = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_bc_bc = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_bd_bd = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_bd_bd = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_be_be = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_be_be = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_bf_bf = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_bf_bf = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c0_c0 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c0_c0 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c1_c1 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c1_c1 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c2_c2 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c2_c2 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c3_c3 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c3_c3 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c4_c4 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c4_c4 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c5_c5 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c5_c5 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c6_c6 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c6_c6 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c7_c7 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c7_c7 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c8_c8 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c8_c8 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_c9_c9 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_c9_c9 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ca_ca = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ca_ca = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_cb_cb = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_cb_cb = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_cc_cc = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_cc_cc = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_cd_cd = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_cd_cd = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ce_ce = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ce_ce = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_cf_cf = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_cf_cf = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d0_d0 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d0_d0 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d1_d1 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d1_d1 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d2_d2 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d2_d2 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d3_d3 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d3_d3 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d4_d4 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d4_d4 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d5_d5 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d5_d5 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d6_d6 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d6_d6 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d7_d7 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d7_d7 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d8_d8 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d8_d8 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_d9_d9 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_d9_d9 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_da_da = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_da_da = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_db_db = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_db_db = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_dc_dc = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_dc_dc = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_dd_dd = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_dd_dd = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_de_de = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_de_de = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_df_df = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_df_df = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e0_e0 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e0_e0 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e1_e1 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e1_e1 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e2_e2 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e2_e2 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e3_e3 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e3_e3 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e4_e4 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e4_e4 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e5_e5 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e5_e5 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e6_e6 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e6_e6 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e7_e7 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e7_e7 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e8_e8 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e8_e8 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_e9_e9 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_e9_e9 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ea_ea = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ea_ea = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_eb_eb = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_eb_eb = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ec_ec = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ec_ec = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ed_ed = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ed_ed = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ee_ee = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ee_ee = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ef_ef = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ef_ef = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f0_f0 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f0_f0 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f1_f1 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f1_f1 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f2_f2 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f2_f2 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f3_f3 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f3_f3 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f4_f4 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f4_f4 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f5_f5 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f5_f5 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f6_f6 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f6_f6 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f7_f7 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f7_f7 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f8_f8 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f8_f8 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_f9_f9 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_f9_f9 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_fa_fa = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_fa_fa = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_fb_fb = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_fb_fb = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_fc_fc = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_fc_fc = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_fd_fd = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_fd_fd = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_fe_fe = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_fe_fe = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_ff_ff = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_ff_ff = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_100_100 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_100_100 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_101_101 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_101_101 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_102_102 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_102_102 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_103_103 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_103_103 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_104_104 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_104_104 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_105_105 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_105_105 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_106_106 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_106_106 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_107_107 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_107_107 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_108_108 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_108_108 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_109_109 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_109_109 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_10a_10a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_10a_10a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_10b_10b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_10b_10b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_10c_10c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_10c_10c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_10d_10d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_10d_10d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_10e_10e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_10e_10e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_10f_10f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_10f_10f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_110_110 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_110_110 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_111_111 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_111_111 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_112_112 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_112_112 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_113_113 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_113_113 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_114_114 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_114_114 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_115_115 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_115_115 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_116_116 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_116_116 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_117_117 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_117_117 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_118_118 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_118_118 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_119_119 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_119_119 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_11a_11a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_11a_11a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_11b_11b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_11b_11b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_11c_11c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_11c_11c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_11d_11d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_11d_11d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_11e_11e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_11e_11e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_11f_11f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_11f_11f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_120_120 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_120_120 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_121_121 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_121_121 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_122_122 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_122_122 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_123_123 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_123_123 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_124_124 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_124_124 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_125_125 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_125_125 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_126_126 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_126_126 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_127_127 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_127_127 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_128_128 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_128_128 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_129_129 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_129_129 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_12a_12a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_12a_12a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_12b_12b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_12b_12b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_12c_12c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_12c_12c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_12d_12d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_12d_12d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_12e_12e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_12e_12e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_12f_12f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_12f_12f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_130_130 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_130_130 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_131_131 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_131_131 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_132_132 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_132_132 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_133_133 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_133_133 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_134_134 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_134_134 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_135_135 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_135_135 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_136_136 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_136_136 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_137_137 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_137_137 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_138_138 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_138_138 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_139_139 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_139_139 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_13a_13a = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_13a_13a = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_13b_13b = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_13b_13b = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_13c_13c = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_13c_13c = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_13d_13d = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_13d_13d = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_13e_13e = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_13e_13e = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_13f_13f = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_13f_13f = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_140_140 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_140_140 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_141_141 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_141_141 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_142_142 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_142_142 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_143_143 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_143_143 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_144_144 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_144_144 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_145_145 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_145_145 = internal dso_local global [69 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_file_name_146_146 = internal dso_local global [77 x i8] zeroinitializer, align 1
@_XamarinAndroidBundledAssembly_name_146_146 = internal dso_local global [69 x i8] zeroinitializer, align 1

; Bundled assembly name buffers, all 69 bytes long
@bundled_assemblies = dso_local local_unnamed_addr global [327 x %struct.XamarinAndroidBundledAssembly] [
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_0_0, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_0_0; char* name
	}, ; 0
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_1_1, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_1_1; char* name
	}, ; 1
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_2_2, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_2_2; char* name
	}, ; 2
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_3_3, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_3_3; char* name
	}, ; 3
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_4_4, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_4_4; char* name
	}, ; 4
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_5_5, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_5_5; char* name
	}, ; 5
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_6_6, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_6_6; char* name
	}, ; 6
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_7_7, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_7_7; char* name
	}, ; 7
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_8_8, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_8_8; char* name
	}, ; 8
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_9_9, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_9_9; char* name
	}, ; 9
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a_a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a_a; char* name
	}, ; 10
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b_b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b_b; char* name
	}, ; 11
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c_c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c_c; char* name
	}, ; 12
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d_d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d_d; char* name
	}, ; 13
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e_e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e_e; char* name
	}, ; 14
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f_f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f_f; char* name
	}, ; 15
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_10_10, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_10_10; char* name
	}, ; 16
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_11_11, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_11_11; char* name
	}, ; 17
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_12_12, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_12_12; char* name
	}, ; 18
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_13_13, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_13_13; char* name
	}, ; 19
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_14_14, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_14_14; char* name
	}, ; 20
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_15_15, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_15_15; char* name
	}, ; 21
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_16_16, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_16_16; char* name
	}, ; 22
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_17_17, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_17_17; char* name
	}, ; 23
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_18_18, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_18_18; char* name
	}, ; 24
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_19_19, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_19_19; char* name
	}, ; 25
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_1a_1a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_1a_1a; char* name
	}, ; 26
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_1b_1b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_1b_1b; char* name
	}, ; 27
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_1c_1c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_1c_1c; char* name
	}, ; 28
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_1d_1d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_1d_1d; char* name
	}, ; 29
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_1e_1e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_1e_1e; char* name
	}, ; 30
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_1f_1f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_1f_1f; char* name
	}, ; 31
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_20_20, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_20_20; char* name
	}, ; 32
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_21_21, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_21_21; char* name
	}, ; 33
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_22_22, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_22_22; char* name
	}, ; 34
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_23_23, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_23_23; char* name
	}, ; 35
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_24_24, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_24_24; char* name
	}, ; 36
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_25_25, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_25_25; char* name
	}, ; 37
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_26_26, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_26_26; char* name
	}, ; 38
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_27_27, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_27_27; char* name
	}, ; 39
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_28_28, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_28_28; char* name
	}, ; 40
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_29_29, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_29_29; char* name
	}, ; 41
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_2a_2a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_2a_2a; char* name
	}, ; 42
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_2b_2b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_2b_2b; char* name
	}, ; 43
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_2c_2c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_2c_2c; char* name
	}, ; 44
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_2d_2d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_2d_2d; char* name
	}, ; 45
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_2e_2e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_2e_2e; char* name
	}, ; 46
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_2f_2f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_2f_2f; char* name
	}, ; 47
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_30_30, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_30_30; char* name
	}, ; 48
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_31_31, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_31_31; char* name
	}, ; 49
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_32_32, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_32_32; char* name
	}, ; 50
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_33_33, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_33_33; char* name
	}, ; 51
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_34_34, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_34_34; char* name
	}, ; 52
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_35_35, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_35_35; char* name
	}, ; 53
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_36_36, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_36_36; char* name
	}, ; 54
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_37_37, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_37_37; char* name
	}, ; 55
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_38_38, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_38_38; char* name
	}, ; 56
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_39_39, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_39_39; char* name
	}, ; 57
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_3a_3a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_3a_3a; char* name
	}, ; 58
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_3b_3b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_3b_3b; char* name
	}, ; 59
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_3c_3c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_3c_3c; char* name
	}, ; 60
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_3d_3d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_3d_3d; char* name
	}, ; 61
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_3e_3e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_3e_3e; char* name
	}, ; 62
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_3f_3f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_3f_3f; char* name
	}, ; 63
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_40_40, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_40_40; char* name
	}, ; 64
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_41_41, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_41_41; char* name
	}, ; 65
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_42_42, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_42_42; char* name
	}, ; 66
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_43_43, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_43_43; char* name
	}, ; 67
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_44_44, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_44_44; char* name
	}, ; 68
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_45_45, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_45_45; char* name
	}, ; 69
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_46_46, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_46_46; char* name
	}, ; 70
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_47_47, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_47_47; char* name
	}, ; 71
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_48_48, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_48_48; char* name
	}, ; 72
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_49_49, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_49_49; char* name
	}, ; 73
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_4a_4a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_4a_4a; char* name
	}, ; 74
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_4b_4b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_4b_4b; char* name
	}, ; 75
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_4c_4c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_4c_4c; char* name
	}, ; 76
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_4d_4d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_4d_4d; char* name
	}, ; 77
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_4e_4e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_4e_4e; char* name
	}, ; 78
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_4f_4f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_4f_4f; char* name
	}, ; 79
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_50_50, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_50_50; char* name
	}, ; 80
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_51_51, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_51_51; char* name
	}, ; 81
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_52_52, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_52_52; char* name
	}, ; 82
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_53_53, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_53_53; char* name
	}, ; 83
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_54_54, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_54_54; char* name
	}, ; 84
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_55_55, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_55_55; char* name
	}, ; 85
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_56_56, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_56_56; char* name
	}, ; 86
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_57_57, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_57_57; char* name
	}, ; 87
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_58_58, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_58_58; char* name
	}, ; 88
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_59_59, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_59_59; char* name
	}, ; 89
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_5a_5a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_5a_5a; char* name
	}, ; 90
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_5b_5b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_5b_5b; char* name
	}, ; 91
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_5c_5c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_5c_5c; char* name
	}, ; 92
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_5d_5d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_5d_5d; char* name
	}, ; 93
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_5e_5e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_5e_5e; char* name
	}, ; 94
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_5f_5f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_5f_5f; char* name
	}, ; 95
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_60_60, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_60_60; char* name
	}, ; 96
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_61_61, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_61_61; char* name
	}, ; 97
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_62_62, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_62_62; char* name
	}, ; 98
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_63_63, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_63_63; char* name
	}, ; 99
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_64_64, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_64_64; char* name
	}, ; 100
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_65_65, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_65_65; char* name
	}, ; 101
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_66_66, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_66_66; char* name
	}, ; 102
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_67_67, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_67_67; char* name
	}, ; 103
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_68_68, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_68_68; char* name
	}, ; 104
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_69_69, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_69_69; char* name
	}, ; 105
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_6a_6a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_6a_6a; char* name
	}, ; 106
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_6b_6b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_6b_6b; char* name
	}, ; 107
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_6c_6c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_6c_6c; char* name
	}, ; 108
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_6d_6d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_6d_6d; char* name
	}, ; 109
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_6e_6e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_6e_6e; char* name
	}, ; 110
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_6f_6f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_6f_6f; char* name
	}, ; 111
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_70_70, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_70_70; char* name
	}, ; 112
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_71_71, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_71_71; char* name
	}, ; 113
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_72_72, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_72_72; char* name
	}, ; 114
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_73_73, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_73_73; char* name
	}, ; 115
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_74_74, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_74_74; char* name
	}, ; 116
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_75_75, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_75_75; char* name
	}, ; 117
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_76_76, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_76_76; char* name
	}, ; 118
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_77_77, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_77_77; char* name
	}, ; 119
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_78_78, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_78_78; char* name
	}, ; 120
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_79_79, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_79_79; char* name
	}, ; 121
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_7a_7a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_7a_7a; char* name
	}, ; 122
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_7b_7b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_7b_7b; char* name
	}, ; 123
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_7c_7c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_7c_7c; char* name
	}, ; 124
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_7d_7d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_7d_7d; char* name
	}, ; 125
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_7e_7e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_7e_7e; char* name
	}, ; 126
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_7f_7f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_7f_7f; char* name
	}, ; 127
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_80_80, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_80_80; char* name
	}, ; 128
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_81_81, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_81_81; char* name
	}, ; 129
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_82_82, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_82_82; char* name
	}, ; 130
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_83_83, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_83_83; char* name
	}, ; 131
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_84_84, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_84_84; char* name
	}, ; 132
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_85_85, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_85_85; char* name
	}, ; 133
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_86_86, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_86_86; char* name
	}, ; 134
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_87_87, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_87_87; char* name
	}, ; 135
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_88_88, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_88_88; char* name
	}, ; 136
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_89_89, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_89_89; char* name
	}, ; 137
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_8a_8a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_8a_8a; char* name
	}, ; 138
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_8b_8b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_8b_8b; char* name
	}, ; 139
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_8c_8c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_8c_8c; char* name
	}, ; 140
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_8d_8d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_8d_8d; char* name
	}, ; 141
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_8e_8e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_8e_8e; char* name
	}, ; 142
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_8f_8f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_8f_8f; char* name
	}, ; 143
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_90_90, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_90_90; char* name
	}, ; 144
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_91_91, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_91_91; char* name
	}, ; 145
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_92_92, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_92_92; char* name
	}, ; 146
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_93_93, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_93_93; char* name
	}, ; 147
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_94_94, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_94_94; char* name
	}, ; 148
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_95_95, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_95_95; char* name
	}, ; 149
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_96_96, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_96_96; char* name
	}, ; 150
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_97_97, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_97_97; char* name
	}, ; 151
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_98_98, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_98_98; char* name
	}, ; 152
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_99_99, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_99_99; char* name
	}, ; 153
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_9a_9a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_9a_9a; char* name
	}, ; 154
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_9b_9b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_9b_9b; char* name
	}, ; 155
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_9c_9c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_9c_9c; char* name
	}, ; 156
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_9d_9d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_9d_9d; char* name
	}, ; 157
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_9e_9e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_9e_9e; char* name
	}, ; 158
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_9f_9f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_9f_9f; char* name
	}, ; 159
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a0_a0, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a0_a0; char* name
	}, ; 160
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a1_a1, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a1_a1; char* name
	}, ; 161
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a2_a2, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a2_a2; char* name
	}, ; 162
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a3_a3, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a3_a3; char* name
	}, ; 163
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a4_a4, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a4_a4; char* name
	}, ; 164
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a5_a5, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a5_a5; char* name
	}, ; 165
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a6_a6, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a6_a6; char* name
	}, ; 166
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a7_a7, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a7_a7; char* name
	}, ; 167
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a8_a8, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a8_a8; char* name
	}, ; 168
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_a9_a9, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_a9_a9; char* name
	}, ; 169
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_aa_aa, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_aa_aa; char* name
	}, ; 170
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ab_ab, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ab_ab; char* name
	}, ; 171
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ac_ac, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ac_ac; char* name
	}, ; 172
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ad_ad, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ad_ad; char* name
	}, ; 173
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ae_ae, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ae_ae; char* name
	}, ; 174
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_af_af, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_af_af; char* name
	}, ; 175
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b0_b0, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b0_b0; char* name
	}, ; 176
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b1_b1, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b1_b1; char* name
	}, ; 177
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b2_b2, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b2_b2; char* name
	}, ; 178
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b3_b3, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b3_b3; char* name
	}, ; 179
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b4_b4, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b4_b4; char* name
	}, ; 180
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b5_b5, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b5_b5; char* name
	}, ; 181
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b6_b6, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b6_b6; char* name
	}, ; 182
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b7_b7, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b7_b7; char* name
	}, ; 183
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b8_b8, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b8_b8; char* name
	}, ; 184
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_b9_b9, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_b9_b9; char* name
	}, ; 185
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ba_ba, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ba_ba; char* name
	}, ; 186
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_bb_bb, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_bb_bb; char* name
	}, ; 187
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_bc_bc, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_bc_bc; char* name
	}, ; 188
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_bd_bd, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_bd_bd; char* name
	}, ; 189
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_be_be, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_be_be; char* name
	}, ; 190
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_bf_bf, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_bf_bf; char* name
	}, ; 191
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c0_c0, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c0_c0; char* name
	}, ; 192
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c1_c1, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c1_c1; char* name
	}, ; 193
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c2_c2, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c2_c2; char* name
	}, ; 194
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c3_c3, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c3_c3; char* name
	}, ; 195
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c4_c4, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c4_c4; char* name
	}, ; 196
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c5_c5, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c5_c5; char* name
	}, ; 197
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c6_c6, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c6_c6; char* name
	}, ; 198
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c7_c7, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c7_c7; char* name
	}, ; 199
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c8_c8, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c8_c8; char* name
	}, ; 200
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_c9_c9, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_c9_c9; char* name
	}, ; 201
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ca_ca, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ca_ca; char* name
	}, ; 202
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_cb_cb, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_cb_cb; char* name
	}, ; 203
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_cc_cc, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_cc_cc; char* name
	}, ; 204
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_cd_cd, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_cd_cd; char* name
	}, ; 205
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ce_ce, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ce_ce; char* name
	}, ; 206
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_cf_cf, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_cf_cf; char* name
	}, ; 207
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d0_d0, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d0_d0; char* name
	}, ; 208
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d1_d1, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d1_d1; char* name
	}, ; 209
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d2_d2, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d2_d2; char* name
	}, ; 210
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d3_d3, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d3_d3; char* name
	}, ; 211
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d4_d4, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d4_d4; char* name
	}, ; 212
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d5_d5, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d5_d5; char* name
	}, ; 213
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d6_d6, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d6_d6; char* name
	}, ; 214
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d7_d7, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d7_d7; char* name
	}, ; 215
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d8_d8, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d8_d8; char* name
	}, ; 216
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_d9_d9, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_d9_d9; char* name
	}, ; 217
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_da_da, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_da_da; char* name
	}, ; 218
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_db_db, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_db_db; char* name
	}, ; 219
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_dc_dc, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_dc_dc; char* name
	}, ; 220
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_dd_dd, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_dd_dd; char* name
	}, ; 221
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_de_de, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_de_de; char* name
	}, ; 222
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_df_df, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_df_df; char* name
	}, ; 223
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e0_e0, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e0_e0; char* name
	}, ; 224
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e1_e1, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e1_e1; char* name
	}, ; 225
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e2_e2, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e2_e2; char* name
	}, ; 226
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e3_e3, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e3_e3; char* name
	}, ; 227
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e4_e4, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e4_e4; char* name
	}, ; 228
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e5_e5, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e5_e5; char* name
	}, ; 229
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e6_e6, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e6_e6; char* name
	}, ; 230
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e7_e7, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e7_e7; char* name
	}, ; 231
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e8_e8, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e8_e8; char* name
	}, ; 232
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_e9_e9, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_e9_e9; char* name
	}, ; 233
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ea_ea, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ea_ea; char* name
	}, ; 234
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_eb_eb, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_eb_eb; char* name
	}, ; 235
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ec_ec, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ec_ec; char* name
	}, ; 236
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ed_ed, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ed_ed; char* name
	}, ; 237
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ee_ee, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ee_ee; char* name
	}, ; 238
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ef_ef, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ef_ef; char* name
	}, ; 239
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f0_f0, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f0_f0; char* name
	}, ; 240
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f1_f1, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f1_f1; char* name
	}, ; 241
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f2_f2, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f2_f2; char* name
	}, ; 242
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f3_f3, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f3_f3; char* name
	}, ; 243
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f4_f4, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f4_f4; char* name
	}, ; 244
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f5_f5, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f5_f5; char* name
	}, ; 245
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f6_f6, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f6_f6; char* name
	}, ; 246
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f7_f7, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f7_f7; char* name
	}, ; 247
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f8_f8, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f8_f8; char* name
	}, ; 248
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_f9_f9, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_f9_f9; char* name
	}, ; 249
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_fa_fa, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_fa_fa; char* name
	}, ; 250
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_fb_fb, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_fb_fb; char* name
	}, ; 251
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_fc_fc, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_fc_fc; char* name
	}, ; 252
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_fd_fd, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_fd_fd; char* name
	}, ; 253
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_fe_fe, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_fe_fe; char* name
	}, ; 254
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_ff_ff, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_ff_ff; char* name
	}, ; 255
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_100_100, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_100_100; char* name
	}, ; 256
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_101_101, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_101_101; char* name
	}, ; 257
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_102_102, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_102_102; char* name
	}, ; 258
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_103_103, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_103_103; char* name
	}, ; 259
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_104_104, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_104_104; char* name
	}, ; 260
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_105_105, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_105_105; char* name
	}, ; 261
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_106_106, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_106_106; char* name
	}, ; 262
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_107_107, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_107_107; char* name
	}, ; 263
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_108_108, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_108_108; char* name
	}, ; 264
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_109_109, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_109_109; char* name
	}, ; 265
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_10a_10a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_10a_10a; char* name
	}, ; 266
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_10b_10b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_10b_10b; char* name
	}, ; 267
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_10c_10c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_10c_10c; char* name
	}, ; 268
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_10d_10d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_10d_10d; char* name
	}, ; 269
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_10e_10e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_10e_10e; char* name
	}, ; 270
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_10f_10f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_10f_10f; char* name
	}, ; 271
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_110_110, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_110_110; char* name
	}, ; 272
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_111_111, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_111_111; char* name
	}, ; 273
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_112_112, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_112_112; char* name
	}, ; 274
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_113_113, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_113_113; char* name
	}, ; 275
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_114_114, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_114_114; char* name
	}, ; 276
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_115_115, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_115_115; char* name
	}, ; 277
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_116_116, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_116_116; char* name
	}, ; 278
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_117_117, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_117_117; char* name
	}, ; 279
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_118_118, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_118_118; char* name
	}, ; 280
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_119_119, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_119_119; char* name
	}, ; 281
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_11a_11a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_11a_11a; char* name
	}, ; 282
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_11b_11b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_11b_11b; char* name
	}, ; 283
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_11c_11c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_11c_11c; char* name
	}, ; 284
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_11d_11d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_11d_11d; char* name
	}, ; 285
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_11e_11e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_11e_11e; char* name
	}, ; 286
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_11f_11f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_11f_11f; char* name
	}, ; 287
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_120_120, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_120_120; char* name
	}, ; 288
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_121_121, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_121_121; char* name
	}, ; 289
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_122_122, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_122_122; char* name
	}, ; 290
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_123_123, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_123_123; char* name
	}, ; 291
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_124_124, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_124_124; char* name
	}, ; 292
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_125_125, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_125_125; char* name
	}, ; 293
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_126_126, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_126_126; char* name
	}, ; 294
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_127_127, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_127_127; char* name
	}, ; 295
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_128_128, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_128_128; char* name
	}, ; 296
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_129_129, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_129_129; char* name
	}, ; 297
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_12a_12a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_12a_12a; char* name
	}, ; 298
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_12b_12b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_12b_12b; char* name
	}, ; 299
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_12c_12c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_12c_12c; char* name
	}, ; 300
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_12d_12d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_12d_12d; char* name
	}, ; 301
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_12e_12e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_12e_12e; char* name
	}, ; 302
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_12f_12f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_12f_12f; char* name
	}, ; 303
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_130_130, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_130_130; char* name
	}, ; 304
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_131_131, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_131_131; char* name
	}, ; 305
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_132_132, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_132_132; char* name
	}, ; 306
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_133_133, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_133_133; char* name
	}, ; 307
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_134_134, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_134_134; char* name
	}, ; 308
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_135_135, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_135_135; char* name
	}, ; 309
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_136_136, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_136_136; char* name
	}, ; 310
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_137_137, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_137_137; char* name
	}, ; 311
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_138_138, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_138_138; char* name
	}, ; 312
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_139_139, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_139_139; char* name
	}, ; 313
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_13a_13a, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_13a_13a; char* name
	}, ; 314
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_13b_13b, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_13b_13b; char* name
	}, ; 315
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_13c_13c, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_13c_13c; char* name
	}, ; 316
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_13d_13d, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_13d_13d; char* name
	}, ; 317
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_13e_13e, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_13e_13e; char* name
	}, ; 318
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_13f_13f, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_13f_13f; char* name
	}, ; 319
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_140_140, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_140_140; char* name
	}, ; 320
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_141_141, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_141_141; char* name
	}, ; 321
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_142_142, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_142_142; char* name
	}, ; 322
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_143_143, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_143_143; char* name
	}, ; 323
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_144_144, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_144_144; char* name
	}, ; 324
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_145_145, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_145_145; char* name
	}, ; 325
	%struct.XamarinAndroidBundledAssembly {
		i32 -1, ; int32_t file_fd
		ptr @_XamarinAndroidBundledAssembly_file_name_146_146, ; char* file_name
		i32 0, ; uint32_t data_offset
		i32 0, ; uint32_t data_size
		ptr null, ; uint8_t* data
		i32 69, ; uint32_t name_length
		ptr @_XamarinAndroidBundledAssembly_name_146_146; char* name
	} ; 326
], align 8

@assembly_store_bundled_assemblies = dso_local local_unnamed_addr global [0 x %struct.AssemblyStoreSingleAssemblyRuntimeData] zeroinitializer, align 8

@assembly_store = dso_local local_unnamed_addr global %struct.AssemblyStoreRuntimeData {
	ptr null, ; uint8_t* data_start
	i32 0, ; uint32_t assembly_count
	i32 0, ; uint32_t index_entry_count
	ptr null; AssemblyStoreAssemblyDescriptor* assemblies
}, align 8

; Strings
@.env.0 = private unnamed_addr constant [7 x i8] c"interp\00", align 1

; Application environment variables name:value pairs
@.env.var.0 = private unnamed_addr constant [15 x i8] c"MONO_GC_PARAMS\00", align 1
@.env.var.1 = private unnamed_addr constant [21 x i8] c"major=marksweep-conc\00", align 1
@.env.var.2 = private unnamed_addr constant [15 x i8] c"MONO_LOG_LEVEL\00", align 1
@.env.var.3 = private unnamed_addr constant [5 x i8] c"info\00", align 1
@.env.var.4 = private unnamed_addr constant [28 x i8] c"XA_HTTP_CLIENT_HANDLER_TYPE\00", align 1
@.env.var.5 = private unnamed_addr constant [42 x i8] c"Xamarin.Android.Net.AndroidMessageHandler\00", align 1

;ApplicationConfig
@.ApplicationConfig.0_android_package_name = private unnamed_addr constant [24 x i8] c"com.companyname.aitools\00", align 1

;DSOCacheEntry
@.DSOCacheEntry.0_name = private unnamed_addr constant [34 x i8] c"libSystem.Globalization.Native.so\00", align 1
@.DSOCacheEntry.1_name = private unnamed_addr constant [35 x i8] c"libSystem.IO.Compression.Native.so\00", align 1
@.DSOCacheEntry.2_name = private unnamed_addr constant [20 x i8] c"libSystem.Native.so\00", align 1
@.DSOCacheEntry.3_name = private unnamed_addr constant [50 x i8] c"libSystem.Security.Cryptography.Native.Android.so\00", align 1
@.DSOCacheEntry.4_name = private unnamed_addr constant [30 x i8] c"libmono-component-debugger.so\00", align 1
@.DSOCacheEntry.5_name = private unnamed_addr constant [32 x i8] c"libmono-component-hot_reload.so\00", align 1
@.DSOCacheEntry.6_name = private unnamed_addr constant [35 x i8] c"libmono-component-marshal-ilgen.so\00", align 1
@.DSOCacheEntry.7_name = private unnamed_addr constant [19 x i8] c"libmonosgen-2.0.so\00", align 1
@.DSOCacheEntry.8_name = private unnamed_addr constant [16 x i8] c"libmonodroid.so\00", align 1
@.DSOCacheEntry.9_name = private unnamed_addr constant [31 x i8] c"libxamarin-debug-app-helper.so\00", align 1

; Metadata
!llvm.module.flags = !{!0, !1, !7, !8, !9, !10}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!llvm.ident = !{!2}
!2 = !{!".NET for Android remotes/origin/release/10.0.1xx @ 01024bb616e7b80417a2c6d320885bfdb956f20a"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{i32 1, !"branch-target-enforcement", i32 0}
!8 = !{i32 1, !"sign-return-address", i32 0}
!9 = !{i32 1, !"sign-return-address-all", i32 0}
!10 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
