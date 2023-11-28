public class aadharDetailsWrapper{


    @Auraenabled public cls_data data;

    @Auraenabled public Integer status_code; 

    @Auraenabled public boolean success;

    @Auraenabled public cls_message message;

    @Auraenabled public String message_code; 

    public class cls_data {

        

        @Auraenabled public String client_id;    

        @Auraenabled public String full_name;   

        @Auraenabled public String aadhaar_number;  

        @Auraenabled public String dob; 

        @Auraenabled public String gender;  

        @Auraenabled public cls_address address;

        @Auraenabled public boolean face_status;

        @Auraenabled public Integer face_score;  

        @Auraenabled public String zip;  

        @Auraenabled public String profile_image;    

        @Auraenabled public boolean has_image;

        @Auraenabled public String raw_xml;  

        @Auraenabled public String zip_data; 

        @Auraenabled public String care_of;  

        @Auraenabled public String share_code;  

        @Auraenabled public boolean mobile_verified;

        @Auraenabled public String reference_id; 

        @Auraenabled public cls_aadhaar_pdf aadhaar_pdf;

    }

    

    public class cls_address {

        @Auraenabled public String country;  

        @Auraenabled public String dist; 

        @Auraenabled public String state;    

        @Auraenabled public String po;   

        @Auraenabled public String loc; 

        @Auraenabled public String vtc;  

        @Auraenabled public String subdist;  

        @Auraenabled public String street;   

        @Auraenabled public String house;   

        @Auraenabled public String landmark; 

    }

    public class cls_aadhaar_pdf {

    }

    public class cls_message {

    }

    

    public static aadharDetailsWrapper parse(String json){

        

        return (aadharDetailsWrapper) System.JSON.deserialize(json, aadharDetailsWrapper.class);

    }


}