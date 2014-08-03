#AWS.config(access_key_id:     'AKIAILSYTXW5KCFGULGA',
           #secret_access_key: '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' )

AWS.config(access_key_id:     'AKIAIZ7ULV6XKP6MJ2NA',
           secret_access_key: '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' )


if Rails.env == 'production'
	S3_BUCKET = AWS::S3.new.buckets['simpleweed-development']
else	
	S3_BUCKET = AWS::S3.new.buckets['simpleweed-development']
end