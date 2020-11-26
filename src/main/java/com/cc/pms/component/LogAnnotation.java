package com.cc.pms.component;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD) //ע����õ�Ŀ��λ��,METHOD�ǿ�ע���ڷ���������
@Retention(RetentionPolicy.RUNTIME) //ע�����ĸ��׶�ִ��
@Documented //�����ĵ�
public @interface LogAnnotation {
    public String value() default "";
}
