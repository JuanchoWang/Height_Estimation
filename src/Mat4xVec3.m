function vec3 = Mat4xVec3(f_mat4,f_vec3)

denom = f_mat4(4,1)*f_vec3(1)+f_mat4(4,2)*f_vec3(2)+f_mat4(4,3)*f_vec3(3)+f_mat4(4,4);

fac = 1/denom;


vec3 = [fac*(f_mat4(1,1)*f_vec3(1) + f_mat4(1,2)*f_vec3(2) + f_mat4(1,3)*f_vec3(3) + f_mat4(1,4)); ...
       fac*(f_mat4(2,1)*f_vec3(1) + f_mat4(2,2)*f_vec3(2) + f_mat4(2,3)*f_vec3(3) + f_mat4(2,4));...
       fac*(f_mat4(3,1)*f_vec3(1) + f_mat4(3,2)*f_vec3(2) + f_mat4(3,3)*f_vec3(3) + f_mat4(3,4))];