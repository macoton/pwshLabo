#include <stdlib.h>
#include <sys/types.h>
#include <pwd.h>
#include <stdarg.h>
void vsystem(const char *fmt, ...)
{
    va_list list;
    va_start(list, fmt);
    char buf[1024];
    vsprintf(buf, fmt, list);
    va_end(list);
    system(buf);
}
int main(int argc, char *argv[]){
    vsystem("id");
    vsystem("ls -al \"%s\"", argv[0]);
    struct passwd *pwnam = getpwnam("runner3");
    if (pwnam == NULL) {
        printf("pwnam: %d\n", pwnam);
        return 1;
    }
    uid_t uid1 = getuid();
    printf("uid: %d\n", uid1);
    uid_t uid2 = pwnam->pw_uid;
    printf("uid: %u\n", uid2);
    int retsetuid = setuid(uid2);
    if (retsetuid) {
        printf("retsetuid: %d\n", retsetuid);
        return 1;
    }
    uid_t uid3 = getuid();
    printf("uid: %d\n", uid3);
}
